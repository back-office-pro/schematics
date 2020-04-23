module Schematics
  module Graphics
    class Stat < Axes::Y
      class << self
        def create(schema, entity:, **args)
          entity = schema.find_entity_by_type(entity)
          super(entity, args)
        end
      end

      def to_s
        value = model_class.send(@agregate.to_sym, to_sql)
        if @field.present?
          @field.format(value)
        else
          value.to_s
        end
      end
    end
  end
end
