module Schematics
  module Attributes
    class Float < Date
      def validators
        super.merge(numericality: true)
      end

      def icon
        :sort_numeric_up
      end
    end
  end
end
