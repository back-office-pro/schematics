# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Modal
        class Component < ApplicationComponent
          delegate :icon, :type, :available_options, :id, to: '@builder.object'
          renders_one_form :builder

          def initialize(builder:)
            super
            @builder = builder
          end

          def input_type = {
            aspect_ratio: :string,
            cached: :boolean,
            confirm: :boolean,
            content_type: :array,
            default: :string,
            depends_on: :string,
            encrypted: :boolean,
            equal_to: :string,
            events: :schema_editor_options_events,
            greater_than: :string,
            greater_than_or_equal_to: :string,
            height: :string,
            hidden: :boolean,
            inverse: :string,
            length: :string,
            less_than: :string,
            less_than_or_equal_to: :string,
            limit: :string,
            max: :string,
            min: :string,
            other_than: :string,
            polymorphic: :boolean,
            precision: :numeric,
            readonly: :boolean,
            required: :boolean,
            scale: :numeric,
            size: :string,
            type: :string,
            unique: :boolean,
            unit: :string,
            values: :array,
            width: :string
          }

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
