# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      delegate :logical?, to: :options

      def available_options = [
        Options::Logical
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

      def to_sql
        ::Arel.sql("COALESCE((#{super.join}), #{logical?.to_s.upcase})")
      end
    end
  end
end
