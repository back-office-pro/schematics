module Schematics
  module Attributes
    class Decimal < Float
      def migration_options
        super + [:precision, :scale]
      end

      def api_param_type
        "double"
      end
    end
  end
end
