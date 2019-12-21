module Schematics
  module Attributes
    class Decimal < Float
      def migration_options
        super + [:precision, :scale]
      end

      def api_param_type
        "double"
      end

      def precision
        @options[:precision]
      end

      def scale
        @options[:scale] || 0
      end

      def bound
        10 ** (precision - scale)
      end

      def validators
        validators = super
        validators[:numericality] = { greater_than: -bound, less_than: bound } unless precision.nil?
        validators
      end
    end
  end
end
