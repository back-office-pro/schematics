# frozen_string_literal: true

require 'countries/iso3166'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Country < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def openai_description = 'An attribute which represents a country name'

      def icon = :earth_europe

      # :reek:FeatureEnvy
      def collection = super.sort_by { [::I18n.transliterate(it.first), it.first] }

      def values = ISO3166::Country.codes

      def format(value)
        value && ISO3166::Country[value].try(:translation, ::I18n.locale.to_s)
      end
    end
  end
end
