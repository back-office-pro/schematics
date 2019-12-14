module Schematics
  module Virtuals
    class Calculation < Virtual
      def parse
        @tokens.map(&:value).join.taint
      end

      def scope
        super + %Q[(from, to) { where("#{parse} >= ? AND #{parse} <= ?", from, to) }]
      end
      
      def has_scope
        super + %Q[, using: [:from, :to]] 
      end

      def icon
        :square_root_alt
      end
    end
  end
end
