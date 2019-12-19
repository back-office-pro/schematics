module Schematics
  module Attributes
    class Date < Attribute
      def filter_scope
        super + %Q[(from, to) {
          return where("#{@entity.type.pluralize}.#{@name} <= ?", to) if from.nil? 
          return where("#{@entity.type.pluralize}.#{@name} >= ?", from) if to.nil?
          where("#{@entity.type.pluralize}.#{@name} >= ? AND #{@entity.type.pluralize}.#{@name} <= ?", from, to)
        }]
      end

      def sort_scope
        super + %Q[sort_direction { order(#{@name}: sort_direction) }]
      end

      def has_filter_scope
        super + %Q[, using: [:from, :to]]
      end

      def format(value)
        I18n.l(value, format: "%A %d %B %Y")
      end

      def icon
        :calendar_alt
      end
    end
  end
end
