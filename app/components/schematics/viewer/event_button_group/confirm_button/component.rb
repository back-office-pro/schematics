# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      module ConfirmButton
        class Component < Button::Component
          def form_css_classes = %w[d-inline btn-check position-relative]

          def text = t(
            event.name,
            default: t('.default'),
            scope: ['.', resource.class.entity.name]
          )

          def target = "confirm-dialog-#{resource.id}-#{event.id}"

          def data = super
            .except(:turbo_method, :action)
            .merge('bs-toggle': 'modal', 'bs-target': "##{target}")
        end
      end
    end
  end
end
