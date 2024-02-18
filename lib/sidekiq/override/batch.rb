# frozen_string_literal: true

module Sidekiq
  module Override
    module Batch
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
                pipeline.hset(@bidkey, 'parent_bid', parent_bid.to_s) if parent_bid
                pipeline.expire(@bidkey, Sidekiq::Batch::BID_EXPIRE_TTL)
              end
            end

            @initialized = true
          end

          @ready_to_queue = []

          begin
            parent = Thread.current[:batch]
            Thread.current[:batch] = self
            yield
          ensure
            Thread.current[:batch] = parent
          end

          return [] if @ready_to_queue.empty?

          Sidekiq.redis do |r|
            r.multi do |pipeline|
              if parent_bid
                pipeline.hincrby("BID-#{parent_bid}", 'children', 1)
                pipeline.hincrby("BID-#{parent_bid}", 'total', @ready_to_queue.size)
                pipeline.expire("BID-#{parent_bid}", Sidekiq::Batch::BID_EXPIRE_TTL)
              end

              pipeline.hincrby(@bidkey, 'pending', @ready_to_queue.size)
              pipeline.hincrby(@bidkey, 'total', @ready_to_queue.size)
              pipeline.expire(@bidkey, Sidekiq::Batch::BID_EXPIRE_TTL)

              pipeline.sadd("#{@bidkey}-jids", [@ready_to_queue].flatten)
              pipeline.expire("#{@bidkey}-jids", Sidekiq::Batch::BID_EXPIRE_TTL)
            end
          end

          @ready_to_queue
        ensure
          Thread.current[:bid_data] = bid_data
        end
      end

      # :reek:FeatureEnvy :reek:TooManyStatements :reek:UncommunicativeVariableName
      def enqueue_callbacks(event, bid) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

          Sidekiq.logger.debug { "Run callback batch bid: #{bid} event: #{event_name} args: #{callback_args.inspect}" } # rubocop:disable Layout/LineLength
          finalizer = Sidekiq::Batch::Callback::Finalize.new
          status = Sidekiq::Batch::Status.new bid
          finalizer.dispatch(status, cb_opts)

          return
        end

        Sidekiq.logger.debug { "Enqueue callback bid: #{bid} event: #{event_name} args: #{callback_args.inspect}" } # rubocop:disable Layout/LineLength

        if callback_args.empty?
          finalizer = Sidekiq::Batch::Callback::Finalize.new
          status = Sidekiq::Batch::Status.new bid
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
  end
end
