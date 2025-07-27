# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Type
      include ::ActiveModel::API

      attr_accessor :value

      def to_h(type = value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        case type
        in 'date'
          { type: 'string', format: 'date' }
        in 'password'
          { type: 'string', format: 'password' }
        in 'datetime'
          { type: 'string', format: 'date-time' }
        in 'float'
          { type: 'number', format: 'float' }
        in 'file'
          { type: 'string', format: 'binary' }
        in Array
          case type.first
          when Hash
            { type: 'array', items: to_h(type.first) }
          else
            { type: 'array', items: { type: type.first } }
          end
        in Hash
          {
            type: 'object',
            properties: type
              .map { |name, value| { name.to_s.delete_suffix('!').to_sym => to_h(value) } }
              .reduce(&:merge),
            required: type
              .keys
              .select { _1.end_with?('!') }
              .map { _1.to_s.delete_suffix('!') }
          }.compact_blank
        else
          { type: }
        end
      end
    end
  end
end
