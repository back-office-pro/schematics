module Schematics
  module Attributes
    class Integer < Float
      def migration_options
        super + [:limit]
      end

      def validators
        validators = super
        validators[:numericality][:only_integer] = true
        validators
      end
    end
  end
end
