# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        delegate :class, to: 'builder.object', prefix: :attribute
        delegate :allowed_association_types, :icon, to: 'builder.object'
        renders_one_form :builder
        option :builder

        def collection = (Attributes.constants - SchemaEditor::Component::DENYLIST)
          .map(&Attributes.method(:const_get))
          .select(&method(:compatible_types))
          .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
          .sort

        def title = attribute_class
          .model_name
          .human

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
