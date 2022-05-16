# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      def open_api_type = 'boolean'
      def icon = :toggle_on

      def to_sql
        super.join
      end

      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          translate(value, default: value.to_s).upcase
        end
      end
    end
  end
end
