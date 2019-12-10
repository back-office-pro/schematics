module Schematics
  module Attributes
    class Float < Date
      def validators
        super.merge(numericality: true)
      end
    end
  end
end
