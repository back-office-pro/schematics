# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Destroy
      class Component < ApplicationComponent
        option :resource
        option :compact, default: -> { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def url = resource_path(resource)

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-toggle': 'modal',
          'bs-target': "##{target}",
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def target = "confirm-dialog-#{resource.id}"

        def title = t('schematics.application.button.destroy')

        def render?
          can?(:destroy, resource)
        end
      end
    end
  end
end
