module Schematics
  module Attributes
    class Float < Date
      def validators
        super.merge(numericality: true)
      end

      def unit
        @options[:unit]
      end

      def format(value)
        value && [value, unit].compact.join(' ')
      end

      def icon
        :sort_numeric_up
      end
    end
  end
end
