# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Modal
        class Component < ApplicationComponent
          delegate :object, to: :builder
          delegate :icon, :id, to: :object
          option :builder

          def available_options = object
            .available_options
            .reject(&:hidden?)
            .sort_by(&:input_type)

          def render?
            available_options.any?
          end

          def target = "schema-editor-options-modal-#{id}"

          def title = object
            .class
            .model_name
            .human
        end
      end
    end
  end
end
