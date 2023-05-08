# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      class Component < ApplicationComponent
        delegate :entity, to: 'resource.class', private: true
        option :resource
        option :compact, default: proc { true }

        def compact? = compact

        def css_classes_for(event)
          [
            'btn',
            "btn-#{event.color}",
            'btn-sm',
            { 'btn-icon-split': !compact? },
            { 'ms-1': !compact? }
          ]
        end

        def data
          return { turbo_method: :patch, turbo_frame: '_top' } unless compact?

          {
            turbo_method: :patch,
            turbo_frame: '_top',
            controller: 'tooltip',
            'bs-toggle': 'tooltip',
            'bs-placement': 'top'
          }
        end

        def events = entity
          .events
          .select { |event| can?(event.name.to_sym, resource) }
          .select { |event| resource.public_send(:"may_#{event.name}?") }
      end
    end
  end
end
