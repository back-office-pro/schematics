# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Options
        class Component < ApplicationComponent
          delegate :object, to: :builder, private: true
          delegate :id, :available_options, to: :object, private: true
          option :builder

          def render? = available_options
            .reject(&:hidden?)
            .any?

          def target = "#schema-editor-options-modal-#{id}"

          def title = t('.title')
        end
      end
    end
  end
end
