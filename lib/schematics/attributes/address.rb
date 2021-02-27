require 'schematics/attributes/string'

module Schematics
  module Attributes
    class Address < String
      def type
        'string'
      end

      def icon
        :map_marker_alt
      end
    end
  end
end
