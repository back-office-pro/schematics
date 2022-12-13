# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      delegate :default, to: :options

      def available_options = [
        Options::Default
      ]

      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          translate(value, default: value.to_s).upcase
        end
      end

      def icon = :toggle_on

      def open_api_type = 'boolean'

      def default = case options.default
                    when true
                      'TRUE'
                    when false
                      'FALSE'
                    else
                      'NULL'
                    end

      def to_sql
        ::Arel.sql("COALESCE(#{super.join}, #{default})")
      end
    end
  end
end
