# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Options
        class Component < ApplicationComponent
          delegate :id, :available_options, to: :@field

          def initialize(field:)
            super
            @field = field
          end

          def render?
            available_options.any?
          end

          def target = "#schema-editor-options-modal-#{id}"

          def title = t('.title')
        end
      end
    end
  end
end
