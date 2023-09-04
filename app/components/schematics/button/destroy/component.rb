# frozen_string_literal: true

module Schematics
  module Button
    module Destroy
      class Component < ApplicationComponent
        option :resource
        option :compact, default: proc { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def icon_class
          'fa-fw' if compact?
        end

        def data = {
          turbo_frame: '_top',
          'bs-toggle': 'modal',
          'bs-target': "##{target}",
          controller: ('tooltip' if compact?)
        }.compact

        def render?
          can?(:destroy, resource)
        end

        def target = "confirm-dialog-#{resource.id}"

        def title
          return unless compact?

          t('schematics.application.button.destroy')
        end
      end
    end
  end
end
