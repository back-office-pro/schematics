require 'schematics/attributes/string'

module Schematics
  module Attributes
    class Address < String
      def icon
        :map_marker_alt
      end
    end
  end
end
