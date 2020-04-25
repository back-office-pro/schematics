module Schematics
  module Graphics
    class Chart
      attr_reader :x, :y
      delegate :icon, :class_name, to: :@entity

      class << self
        def create(schema, entity:, type:, x:, y:)
          entity = schema.find_entity_by_type(entity)
          x = Axes::X.create(entity, x)
          y = Axes::Y.create(entity, y)
          new(entity, type, x, y)
        end
      end

      def initialize(entity, type, x, y)
        @entity = entity
        @type = type
        @x = x
        @y = y
      end

      def type
        :"#{@type}_chart"
      end

      def icon
        :"chart_#{@type}"
      end

      def title
        [@y.title, I18n.t('schematics.dashboard.home.graphics.by'), @x.title].join(' ')
      end

      def to_h
        class_name.constantize.
          send(x.agregate.to_sym, x.to_sql).
          send(y.agregate.to_sym, y.to_sql).
          map do |key, value|
            [x.field&.format(key) || key, y.field&.format(value) || value]
          end.to_h
      end
    end
  end
end
