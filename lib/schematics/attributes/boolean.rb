module Schematics
  module Attributes
    class Boolean < Attribute
      def scope
        super + %Q[{ where(#{@name}: true) }]
      end

      def has_scope
        super + %Q[, type: :boolean]
      end

      def icon
        :toggle_on
      end
    end
  end
end
