module Schematics
  module Virtuals
    class Calculation < Virtual
      def to_sql
        super.join
      end
      
      def scope
        if joins.empty?
          super + %Q[(from, to) {
            return where("#{to_sql} <= ?", to) if from.nil? 
            return where("#{to_sql} >= ?", from) if to.nil?
            where("#{to_sql} >= ? AND #{to_sql} <= ?", from, to)
          }]
        else
          super + %Q[(from, to) {
            return joins(#{joins}).where("#{to_sql} <= ?", to) if from.nil? 
            return joins(#{joins}).where("#{to_sql} >= ?", from) if to.nil?
            joins(#{joins}).where("#{to_sql} >= ? AND #{to_sql} <= ?", from, to)
          }]
        end
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
