# frozen_string_literal: true

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
        super.sort_alphabetical_by(&:last)
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
