# frozen_string_literal: true

module Schematics
  module Attributes
    class Mime < String
      def format(value)
        ::Mime::Type
          .lookup(value)
          .symbol
          .upcase
      end

      def icon
        :file
      end
    end
  end
end
