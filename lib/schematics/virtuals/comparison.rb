# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          translate(value, default: value.to_s).upcase
        end
      end

      def search_predicate = :eq

      def icon = :toggle_on

      def open_api_type = 'boolean'

      def to_sql = "(#{super.join})"
    end
  end
end
