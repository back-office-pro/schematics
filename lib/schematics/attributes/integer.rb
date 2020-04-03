module Schematics
  module Attributes
    class Integer < Float
      def migration_options
        super + [:limit]
      end

      def validators
        super.merge(numericality: { only_integer: true })
      end
    end
  end
end
