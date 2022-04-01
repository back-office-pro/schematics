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

        def render?
          can?(:destroy, @resource)
        end

        def css_classes
          [
            'btn',
            'btn-danger',
            'btn-sm',
            ('btn-icon-split' unless compact?),
            ('ms-2' unless compact?)
          ].compact
        end

        def data
          return { confirm: true } unless compact?

          { confirm: true, 'bs-toggle': 'tooltip', 'bs-placement': 'top' }
        end

        def title
          return unless compact?

          t('schematics.application.button.destroy')
        end

        def compact?
          @compact
        end
      end
    end
  end
end
