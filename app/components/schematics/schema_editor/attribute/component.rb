# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        delegate :class, to: '@builder.object', prefix: :attribute
        delegate :entity, :icon, :type, to: '@builder.object'
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def associations_collection = entity
          .schema
          .entities
          .reject(&:core?)
          .map(&:name)
          .sort

        def collection = (Attributes.constants - SchemaEditor::Component::DENYLIST)
          .map(&Attributes.method(:const_get))
          .select(&method(:compatible_types))
          .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
          .sort

        def title = Attributes
          .const_get(type.camelize.to_sym)
          .model_name
          .human

        def wrapper = :input_group

        private

        def compatible_types(constant)
          return true if constant == attribute_class

          constant.superclass != Attributes::Attribute && (
            constant.superclass == attribute_class ||
            constant.superclass == attribute_class.superclass
          )
        end
      end
    end
  end
end
