# frozen_string_literal: true

module Schematics
  module Entities
    class OptionsStruct < OpenStruct
      def hidden?
        hidden
      end

      def readonly?
        readonly
      end

      def required?
        required
      end

      def unique?
        unique
      end
    end
  end
end
