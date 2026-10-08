# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Color < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      REGEX = /\A#(?:\h{3}){1,2}\z/

      def default = '#000000'

      def openai_description = 'An attribute which represents an hexadecimal color'

      def icon = :palette

      def validators = super.merge(
        allow_blank:,
        format: { with: REGEX, message: :color }
      )
    end
  end
end
