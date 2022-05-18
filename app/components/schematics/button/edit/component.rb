# frozen_string_literal: true

module Schematics
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :class, to: :@resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true

        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def compact? = @compact

        def css_classes = [
          'btn',
          'btn-primary',
          'btn-sm',
          ('btn-icon-split' unless compact?),
          ('ms-2' unless compact?)
        ].compact

        def data
          return { turbo_frame: '_top' } unless compact?

          {
            turbo_frame: '_top',
            controller: 'tooltip',
            'bs-toggle': 'tooltip',
            'bs-placement': 'top'
          }
        end

        def render?
          can?(:edit, @resource)
        end

        def title
          return unless compact?

          t('.text')
        end
      end
    end
  end
end
