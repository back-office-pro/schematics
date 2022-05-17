# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Address < String
      def encrypted? = true

      def icon = :location_dot
    end
  end
end
