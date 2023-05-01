# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Address < String
      def available_options = super.excluding(Options::Translated)

      def icon = :location_dot
    end
  end
end
