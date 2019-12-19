module Schematics
  module Attributes
    class Boolean < Attribute
      def filter_scope
        super + %Q[{ where(#{@name}: true) }]
      end

      def sort_scope
        super + %Q[sort_direction { order(#{@name}: sort_direction) }]
      end

      def has_filter_scope
        super + %Q[, type: :boolean]
      end

      def icon
        :toggle_on
      end
    end
  end
end
