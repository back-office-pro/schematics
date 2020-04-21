module Schematics
  module Graphics
    class Stat
      include Behaviours::Visualizable
      attr_reader :field
      delegate :icon, :class_name, to: :@entity

      class << self
        def create(schema, entity:, agregate:, field: nil)
          entity = schema.find_entity_by_type(entity)
          field = entity.find_field_by_name(field)
          new(entity, agregate, field)
        end
      end

      def initialize(entity, agregate, field)
        @entity = entity
        @agregate = agregate
        @field = field
      end

      def title
        [
          I18n.t(@agregate.to_sym, scope: 'schematics.dashboard.home.graphics.agregate'),
          (class_name.constantize.human_attribute_name(@field.name).pluralize if field.present?),
          I18n.t('schematics.dashboard.home.graphics.of'),
          class_name.constantize.model_name.human.downcase.pluralize,
        ].join(' ')
      end

      def to_s
        value = class_name.constantize.send(@agregate.to_sym, to_sql)
        if @field.present?
          @field.format(value)
        else
          value.to_s
        end
      end
    end
  end
end
