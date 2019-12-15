module Schematics
  module Attributes
    class Date < Attribute
      def scope
        super + %Q[(from, to) { where("#{@name} >= ? AND #{@name} <= ?", from, to) }]
      end

      def has_scope
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
