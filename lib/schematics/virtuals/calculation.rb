module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable

      def to_sql
        super.join
      end

      def unit
        @options[:unit]
      end

      def scale
        @options[:scale]
      end

      def format(value)
        return value.to_s if value.is_a?(::StandardError)
        [scale.nil? ? value : value.round(scale), unit].compact.join(' ')
      end

      def icon
        :square_root_alt
      end
    end
  end
end
