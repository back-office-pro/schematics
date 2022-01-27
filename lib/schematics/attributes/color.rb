# frozen_string_literal: true

module Schematics
  module Attributes
    class Color < String
      def icon
        :palette
      end
    end
  end
end
