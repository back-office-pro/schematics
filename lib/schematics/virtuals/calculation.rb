module Schematics
  module Virtuals
    class Calculation < Virtual
      def parse
        @tokens.map(&:value).join.taint
      end

      def scope
        super + %Q[(from, to) {
          return where("#{parse} <= ?", to) if from.nil? 
          return where("#{parse} >= ?", from) if to.nil?
          where("#{parse} >= ? AND #{parse} <= ?", from, to)
        }]
      end
      
      def has_scope
        super + %Q[, using: [:from, :to]] 
      end

      def unit
        @options[:unit]
      end

      def scale
        @options[:scale]
      end

      def format(value)
        [scale.nil? ? value : value.round(scale), unit].compact.join(' ')
      end

      def icon
        :square_root_alt
      end
    end
  end
end
