module Schematics
  module Renderers
    class Renderer
      attr_accessor :renderable, :order

      FORMATTER_VAL_KEY = "$VAL"

      def initialize(renderable, order, visible = false, formatter = nil)
        @renderable = renderable
        @order = order
        @visible = visible
        @formatter = formatter || FORMATTER_VAL_KEY
      end

      def visible?
        @visible
      end

      def format(value)
        @formatter.sub(FORMATTER_VAL_KEY, value.to_s)
      end
    end
  end
end
