# frozen_string_literal: true

module Sidekiq
  # :reek:InstanceVariableAssumption :reek:MissingSafeMethod :reek:TooManyInstanceVariables
  class Batch # rubocop:disable Metrics/ClassLength
    class << self
      # :reek:TooManyStatements :reek:UncommunicativeVariableName
      def enqueue_callbacks(event, bid) # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity
        event_name = event.to_s
        batch_key = "BID-#{bid}"
        callback_key = "#{batch_key}-callbacks-#{event_name}"
        already_processed, _, callbacks, queue, parent_bid, callback_batch = Sidekiq.redis do |r|
          r.multi do |pipeline|
            pipeline.hget(batch_key, event_name)
            pipeline.hset(batch_key, event_name, 'true')
            pipeline.smembers(callback_key)
            pipeline.hget(batch_key, 'callback_queue')
            pipeline.hget(batch_key, 'parent_bid')
            pipeline.hget(batch_key, 'callback_batch')
          end
        end

        return if already_processed == 'true'

        queue ||= 'default'
        parent_bid = nil if parent_bid.blank?
        callback_args = callbacks.reduce([]) do |memo, jcb|
          cb = Sidekiq.load_json(jcb)
          memo << [cb['callback'], event_name, cb['opts'], bid, parent_bid]
        end

        opts = { 'bid' => bid, 'event' => event_name } # rubocop:disable Style/StringHashKeys

        if callback_batch
          cb_opts = callback_args.first&.at(2) || opts

          Sidekiq.logger.debug do
            "Run callback batch bid: #{bid} event: #{event_name} args: #{callback_args.inspect}"
          end
          finalizer = Sidekiq::Batch::Callback::Finalize.new
          status = Status.new bid
          finalizer.dispatch(status, cb_opts)

          return
        end

        Sidekiq.logger.debug do
          "Enqueue callback bid: #{bid} event: #{event_name} args: #{callback_args.inspect}"
        end

        if callback_args.empty?
          finalizer = Sidekiq::Batch::Callback::Finalize.new
          status = Status.new bid
          finalizer.dispatch(status, opts)
        else
          cb_batch = new
          cb_batch.callback_batch = 'true'
          Sidekiq.logger.debug { "Adding callback batch: #{cb_batch.bid} for batch: #{bid}" }
          cb_batch.on(:complete, 'Sidekiq::Batch::Callback::Finalize#dispatch', opts)
          cb_batch.jobs do
            push_callbacks callback_args, queue
          end
        end
      end
    end

    # :reek:NilCheck :reek:UncommunicativeVariableName
    def initialize(existing_bid = nil)
      @bid = existing_bid || SecureRandom.urlsafe_base64(10)
      @existing = existing_bid.present?
      @initialized = false
      @created_at = Time.now.utc.to_f
      @bidkey = "BID-#{@bid}"
      @queued_jids = []
      @pending_jids = []

      @incremental_push = !Sidekiq.default_configuration[:batch_push_interval].nil?
      @batch_push_interval = Sidekiq.default_configuration[:batch_push_interval]
    end

    # :reek:TooManyStatements :reek:UncommunicativeVariableName
    def jobs # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      raise NoBlockGivenError unless block_given?

      bid_data = Thread.current[:bid_data]
      Thread.current[:bid_data] = []

      begin
        if !@existing && !@initialized
          parent_bid = Thread.current[:batch].bid if Thread.current[:batch]

          Sidekiq.redis do |r|
            r.multi do |pipeline|
              pipeline.hset(@bidkey, 'created_at', @created_at)
              pipeline.expire(@bidkey, BID_EXPIRE_TTL)
              if parent_bid
                pipeline.hset(@bidkey, 'parent_bid', parent_bid.to_s)
                pipeline.hincrby("BID-#{parent_bid}", 'children', 1)
              end
            end
          end

          @initialized = true
        end

        @queued_jids = []
        @pending_jids = []

        begin
          parent = Thread.current[:batch]
          Thread.current[:batch] = self
          Thread.current[:parent_bid] = parent_bid
          yield
        ensure
          Thread.current[:batch] = parent
          Thread.current[:parent_bid] = nil
        end

        return [] if @queued_jids.empty?

        conditional_redis_increment!(force: true)

        Sidekiq.redis do |r|
          r.multi do |pipeline|
            pipeline.expire("BID-#{parent_bid}", BID_EXPIRE_TTL) if parent_bid

            pipeline.expire(@bidkey, BID_EXPIRE_TTL)

            pipeline.sadd("#{@bidkey}-jids", @queued_jids)
            pipeline.expire("#{@bidkey}-jids", BID_EXPIRE_TTL)
          end
        end

        @queued_jids
      ensure
        Thread.current[:bid_data] = bid_data
      end
    end

    def increment_job_queue(jid)
      @queued_jids << jid
      @pending_jids << jid
      conditional_redis_increment!
    end

    # :reek:BooleanParameter :reek:ControlParameter :reek:UncommunicativeVariableName
    def conditional_redis_increment!(force: false)
      return unless should_increment? || force

      parent_bid = Thread.current[:parent_bid]
      Sidekiq.redis do |r|
        r.multi do |pipeline|
          if parent_bid
            pipeline.hincrby("BID-#{parent_bid}", 'total', @pending_jids.length)
            pipeline.expire("BID-#{parent_bid}", BID_EXPIRE_TTL)
          end

          pipeline.hincrby(@bidkey, 'pending', @pending_jids.length)
          pipeline.hincrby(@bidkey, 'total', @pending_jids.length)
          pipeline.expire(@bidkey, BID_EXPIRE_TTL)
        end
      end
      @pending_jids = []
    end

    def should_increment?
      return false unless @incremental_push
      return true if @batch_push_interval.zero? || @queued_jids.length == 1

      now = Time.now.to_f
      @last_increment ||= now
      return false unless @last_increment + @batch_push_interval > now

      @last_increment = now
      true
    end
  end
end
