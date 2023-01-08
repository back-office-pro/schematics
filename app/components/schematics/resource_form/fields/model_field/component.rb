# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module ModelField
        class Component < Fields::Component
          delegate :new_record?, to: :resource

          def collection = field
            .collection
            .map { _1.push(class: model_field_collection_class(_1.second, field)) }

          def prompt = t('prompt', attribute_name:)

          def data = {
            controller: 'dropdown',
            'dropdown-depends-on': "#{resource.class.entity.name}[#{field.depends_on}]"
          }

          private

          def model_field_collection_class(key, field)
            'd-none' if new_record? || !key.start_with?(resource.public_send(field.depends_on))
          end

          def attribute_name = resource
            .class
            .human_attribute_name(name)
            .downcase
        end
      end
    end
  end
end
