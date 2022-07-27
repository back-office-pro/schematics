# frozen_string_literal: true

module Schematics
  module Button
    module Destroy
      class Component < ApplicationComponent
        def initialize(resource:, compact: true)
          super
          @resource = resource
          @compact = compact
        end

        def compact? = @compact

        def css_classes = [
          'btn',
          'btn-danger',
          'btn-sm',
          { 'btn-icon-split': !compact? },
          { 'ms-2': !compact? }
        ]

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
          can?(:destroy, @resource)
        end

        def target = "confirm-dialog-#{@resource.id}"

        def title
          return unless compact?

          t('schematics.application.button.destroy')
        end
      end
    end
  end
end
