module Schematics
  module Graphics
    class Axis
      include Behaviours::Visualizable
      attr_reader :agregate, :field
      delegate :class_name, to: :@entity

      class << self
        def create(entity, agregate:, field: nil)
          if field == 'created_at'
            field = created_at_attribute(entity)
          else
            field = entity.find_field_by_name(field)
          end
          new(entity, agregate, field)
        end

        private

        # TODO
        # Check how we handle :id, :created_at, :deleted_at, :slug...
        def created_at_attribute(entity)
          Attributes::Attribute.create(entity, type: 'date', name: 'created_at')
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
          (class_name.constantize.human_attribute_name(@field.name).downcase if @field.present?),
          (I18n.t('schematics.dashboard.home.graphics.of') if @field.nil?),
          (class_name.constantize.model_name.human.downcase.pluralize if @field.nil?),
        ].join(' ')
      end
    end
  end
end
