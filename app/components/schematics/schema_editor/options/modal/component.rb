# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Modal
        class Component < ApplicationComponent
          delegate :icon, :type, :available_options, :id, to: 'builder.object'
          renders_one_form :builder
          option :builder

          def render?
            available_options.any?
          end

          def target = "schema-editor-options-modal-#{id}"

          def title = Attributes
            .const_get(type.camelize.to_sym)
            .model_name
            .human
        end
      end
    end
  end
end
