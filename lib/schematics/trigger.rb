# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Trigger
    include ::ActiveModel::API
    attr_accessor :action, :callback

    def method_name = "after_#{action}"

    def to_str
      case [action, callback]
      in ['create', *] | ['save', *] | ['destroy', *]
        <<~RUBY
          #{method_name} :#{method_name}
          def #{method_name}
            #{method_body}
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
            #{method_body}
          rescue StandardError
          end
        RUBY
      end
    end

    private

    def method_body
      return unless callback

      Tokens::Tokenizer
        .tokenize(callback)
        .map(&:value)
        .join
    end
  end
end
