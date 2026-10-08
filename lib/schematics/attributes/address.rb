# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Address < String
      include Behaviours::Untranslatable

      def openai_description = 'An attribute which represents a postal address'

      def icon = :location_dot
    end
  end
end
