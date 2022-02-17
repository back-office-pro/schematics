# frozen_string_literal: true

module Schematics
  module Attributes
    class Color < String
      REGEX = /\A#(?:\h{3}){1,2}\z/

      def validators
        super.merge({ allow_blank:, format: { with: REGEX, message: :color } }.compact_blank)
      end

      def default
        '#2c3e50'.to_json
      end

      def icon
        :palette
      end
    end
  end
end
