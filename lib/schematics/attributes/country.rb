# frozen_string_literal: true

require 'countries/iso3166'
require 'sort_alphabetical'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Country < String
      include Behaviours::Enumerable

      def icon = :earth_europe

      def collection = super.sort_alphabetical

      def values = ISO3166::Country.codes

      def format(value)
        value && ISO3166::Country[value].try(:translation, ::I18n.locale.to_s)
      end
    end
  end
end
