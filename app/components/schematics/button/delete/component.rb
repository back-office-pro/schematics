# frozen_string_literal: true

module Schematics
  module Button
    module Delete
      class Component < ApplicationComponent
        option :resource
        option :compact, default: -> { true }

        def data = {
          controller: 'tooltip',
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def title = t('.title')

        def render?
          can?(:delete, resource)
        end
      end
    end
  end
end
