# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Citext < String
      include Behaviours::Translatable

      def available_options = super.push(
        Options::Translated
      )

      def case_sensitive? = false

      def database_type = 'citext'
    end
  end
end
