# frozen_string_literal: true

module Schematics
  class Trigger
    attr_reader :action

    def initialize(action:, callback:)
      @action = action
      @callback = callback
    end

    def to_str
      case [@action, callback]
      in ['create', *] | ['save', *] | ['destroy', *]
        <<~RUBY
          #{method_name} :#{method_name}
          def #{method_name}
            #{callback}
            save!
          rescue StandardError
          end
        RUBY
      in [*, nil]
        <<~RUBY
          def #{method_name}; end
        RUBY
      else
        <<~RUBY
          def #{method_name}
            #{callback}
          rescue StandardError
          end
        RUBY
      end
    end

    def method_name
      "after_#{@action}"
    end

    private

    def callback
      return unless @callback

      Tokens::Tokenizer
        .tokenize(@callback)
        .map(&:value)
        .join
    end
  end
end
