# frozen_string_literal: true

require 'schematics/attributes/string'
require 'schematics/behaviours/enumerable'
require 'countries/iso3166'
require 'sort_alphabetical'

module Schematics
  module Attributes
    class Country < String
      include Behaviours::Enumerable

      def icon
        :globe_europe
      end

      def input_collection
        super
          .map(&:reverse)
          .sort_alphabetical
          .map(&:reverse)
      end

      def format(value)
        value && ISO3166::Country[value].try(:translation, I18n.locale.to_s)
      end

      def values
        ISO3166::Country.codes
      end
    end
  end
end
