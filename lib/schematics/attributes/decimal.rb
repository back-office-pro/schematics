require 'schematics/attributes/float'

module Schematics
  module Attributes
    class Decimal < Float
      def precision
        @options[:precision]
      end

      def scale
        @options[:scale] || 0
      end

      def bound
        10**(precision - scale)
      end

      def validators
        validators = super
        unless precision.nil?
          validators[:numericality][:greater_than] = -bound
          validators[:numericality][:less_than] = bound
        end
        validators
      end
    end

    protected

    def migration_options
      super.concat %i[precision scale]
    end
  end
end
