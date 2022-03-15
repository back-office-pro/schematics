# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Color < String
      REGEX = /\A#(?:\h{3}){1,2}\z/

      def validators
        super.merge({ allow_blank:, format: { with: REGEX, message: :color } }.compact_blank)
      end

      def default
        '#000000'
      end

      def icon
        :palette
      end
    end
  end
end
