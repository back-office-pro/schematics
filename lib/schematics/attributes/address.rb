module Schematics
  module Attributes
    class Address < Text
      def type
        "string"
      end

      def icon
        :map_marker_alt
      end
    end
  end
end
