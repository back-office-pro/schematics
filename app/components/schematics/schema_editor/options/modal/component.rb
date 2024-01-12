# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Modal
        class Component < ApplicationComponent
          delegate :object, to: :builder
          delegate :icon, :id, to: :object
          option :builder

          def data = {
            controller: 'dropdown',
            'dropdown-create-value': true,
            'dropdown-create-filter-value': '^[a-z_][a-z_]+$'
          }

          def available_options = builder
            .object
            .available_options
            .reject(&:hidden?)
            .sort_by(&:input_type)

          def include_blank(name)
            t 'prompt', attribute_name: Schematics::Options::Wrapper
              .human_attribute_name(name)
              .singularize
              .downcase
          end

          def render?
            available_options.any?
          end

          def target = "schema-editor-options-modal-#{id}"

          def title = builder
            .object
            .class
            .model_name
            .human
        end
      end
    end
  end
end
