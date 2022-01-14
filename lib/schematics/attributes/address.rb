# frozen_string_literal: true

module Schematics
  module Attributes
    class Address < String
      def icon
        :map_marker_alt
      end
    end
  end
end
