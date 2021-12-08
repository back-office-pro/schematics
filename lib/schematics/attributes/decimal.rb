# frozen_string_literal: true

module Schematics
  module Attributes
    class Decimal < Float
      delegate :precision, to: :options

      def bound
        10**(precision - scale.to_i)
      end

      def validators
        validators = super
        validators[:numericality][:greater_than] = -bound if precision
        validators[:numericality][:less_than] = bound if precision
        validators
      end

      protected

      def migration_options
        super.concat %i[precision scale]
      end
    end
  end
end
