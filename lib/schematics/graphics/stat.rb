module Schematics
  module Graphics
    class Stat < Axes::Y
      class << self
        def create(schema, entity:, **args)
          entity = schema.find_entity_by_name(entity)
          super(entity, **args)
        end
      end

      def to_s
        value = model_class.send(@agregate.to_sym, to_sql)
        return @field.format(value) if @field.present?
        value.to_s
      end
    end
  end
end
