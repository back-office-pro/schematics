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
        super || 'FR'
      end

      def validators
        super.merge(inclusion: { in: ISO3166::Country.codes }, allow_nil: !required?)
      end

      def input_collection
        ISO3166::Country
          .codes
          .collect { |country| [format(country), country] }
          .sort_alphabetical
          .map(&:reverse)
      end

      def format(value)
        value && ISO3166::Country[value].try(:translation, I18n.locale.to_s)
      end
    end
  end
end
