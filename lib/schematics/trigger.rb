# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Trigger
    include Behaviours::Identifiable
    include ::ActiveModel::API

    ACTIONS = %w[
      after_create
      after_destroy
      after_save
      before_create
      before_destroy
      before_save
    ].freeze

    validates :callback,
              presence: true,
              format: { with: Tokens::Tokenizer::REGEX, message: :function }
    validates :action,
              presence: true,
              inclusion: { in: ACTIONS }
    attr_accessor :action, :callback

    def to_str
      case [action, callback]
      in ['before_create', *] | ['before_save', *] | ['before_destroy', *]
        <<~RUBY
          #{action} :#{method_name}
          def #{method_name}
            #{method_body}
          rescue StandardError
          end
        RUBY
      in ['after_create', *] | ['after_save', *] | ['after_destroy', *]
        <<~RUBY
          #{action} :#{method_name}
          def #{method_name}
            #{method_body}
            save!
          rescue StandardError
          end
        RUBY
      in [*, nil]
        <<~RUBY
          def #{action}; end
        RUBY
      else
        <<~RUBY
          def #{action}
            #{method_body}
            save!
          rescue StandardError
          end
        RUBY
      end
    end

    private

    def method_name = [action, id].join('_')

    def method_body
      return unless callback

      Tokens::Tokenizer
        .tokenize(callback)
        .map(&:value)
        .join
    end
  end
end
