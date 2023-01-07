# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module BelongsTo
        class Component < Fields::Component
          delegate :column_name, :inverse_entity, to: :field
          delegate :model_class, to: :inverse_entity
          delegate :gender, to: :model_class, private: true

          def collection = model_class
            .all
            .map { [_1.to_s, _1.id] }
            .sort

          def prompt = t('prompt', gender:, attribute_name:)

          def data = { controller: 'dropdown' }

          def label
            attribute_name.humanize
          end

          protected

          def attribute_name = resource
            .class
            .human_attribute_name(name)
            .downcase
        end
      end
    end
  end
end
