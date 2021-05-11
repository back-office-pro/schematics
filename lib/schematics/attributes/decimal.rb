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
        super.merge(
          {
            numericality: {
              greater_than: (-bound if precision),
              less_than: (bound if precision),
            }.compact,
          }.compact_blank
        )
      end
    end

    protected

    def migration_options
      super.concat %i[precision scale]
    end
  end
end
