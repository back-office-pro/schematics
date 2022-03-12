# frozen_string_literal: true

module Schematics
  class Trigger
    attr_reader :action

    def initialize(action:, callback:, trigger: :before)
      @action = action
      @callback = callback
      @trigger = trigger
    end

    def to_str
      return instance_method unless before?

      <<~RUBY.chomp
        #{method_name} :#{method_name}
        #{instance_method}
      RUBY
    end

    def method_name
      [@trigger, @action].join('_')
    end

    private

    def before?
      @trigger == :before
    end

    def instance_method
      if callback
        <<~RUBY
          def #{method_name}
            #{callback}
          rescue StandardError
          end
        RUBY
      else
        <<~RUBY
          def #{method_name}; end
        RUBY
      end
    end

    def callback
      return unless @callback

      Tokens::Tokenizer
        .tokenize(@callback)
        .map(&:value)
        .join
    end
  end
end
