require 'schematics/attributes/string'
require 'countries/iso3166'
require 'sort_alphabetical'

module Schematics
  module Attributes
    class Country < String
      def icon
        :globe_europe
      end

      def input_type
        :select
      end

      def default
        super || values.first
      end

      def validators
        super.merge(inclusion: { in: values }, allow_nil: !required?)
      end

      def input_collection
        values
          .collect { |country| [format(country), country] }
          .sort_alphabetical
          .map(&:reverse)
      end

      def format(value)
        value && ISO3166::Country[value].try(:translation, I18n.locale.to_s)
      end

      private

      def values
        ISO3166::Country.codes
      end
    end
  end
end
