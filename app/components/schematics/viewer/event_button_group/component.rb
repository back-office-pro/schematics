# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      class Component < ApplicationComponent
        delegate :entity, to: '@resource.class', private: true

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def compact? = @compact

        def css_classes
          [
            'btn',
            'btn-primary',
            'btn-sm',
            ('btn-icon-split' unless compact?),
            ('ms-2' unless compact?)
          ].compact
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

        def events
          entity
            .events
            .select { |event| can?(event.name.to_sym, @resource) }
            .select { |event| @resource.public_send(:"may_#{event.name}?") }
        end
      end
    end
  end
end
