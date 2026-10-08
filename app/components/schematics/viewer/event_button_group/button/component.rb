# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      module Button
        class Component < ApplicationComponent
          option :resource
          option :event
          option :compact
          option :last

          def compact? = compact

          def last?
            event == last
          end

          def button_css_classes
            class_names(
              'btn',
              "btn-#{event.color}",
              'btn-sm',
              'btn-icon-split': !compact?,
              'ms-1': !compact?,
              'me-1': !compact? && last?
            )
          end

          def url = trigger_resource_path(resource, event)

          def data = {
            turbo_method: :patch,
            turbo_frame: '_top',
            controller: 'tooltip',
            action: 'click->application#disableWith',
            'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
          }.compact
        end
      end
    end
  end
end
