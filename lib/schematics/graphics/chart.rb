module Schematics
  module Graphics
    class Chart
      attr_reader :x, :y
      delegate :icon, to: :@entity

      class << self
        def create(schema, entity:, type:, x:, y:)
          entity = schema.find_entity_by_type(entity)
          x = Axis.create(entity, x)
          y = Axis.create(entity, y)
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

      def title
        [@y.title, @x.title].join(' ')
      end

      def to_h
        model_class.
          send(x.agregate.to_sym, x.to_sql).
          send(y.agregate.to_sym, y.to_sql).
          map do |key, value|
            [x.field&.format(key) || key, y.field&.format(value) || value]
          end.to_h
      end

      private

      def model_class
        @entity.type.camelize.constantize
      end
    end
  end
end
