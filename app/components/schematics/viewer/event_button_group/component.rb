# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      class Component < ApplicationComponent
        delegate :entity, to: 'resource.class', private: true
        option :resource
        option :compact, default: -> { true }

        def compact? = compact

        def css_classes_for(event)
          class_names(
            'btn',
            "btn-#{event.color}",
            'btn-sm',
            'btn-icon-split': !compact?,
            'ms-1': !compact?,
            'me-1': !compact? && event != events.last
          )
        end

        def path_for(event)
          polymorphic_path(
            [event.state_machine_name.to_sym, event.name.to_sym, resource],
            format: nil
          )
        end

        def icon_class
          'fa-fw' if compact?
        end

        def role = 'button'

        def onclick = <<~JAVASCRIPT
          this.classList.add('disabled')
        JAVASCRIPT

        def data = {
          turbo_method: :patch,
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def events = entity
          .events
          .select { |event| can?(event.name.to_sym, resource) }
          .select { |event| resource.public_send(:"may_#{event.suffixed_name}?") }
      end
    end
  end
end
