# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        option :resource
        option :compact, default: -> { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def title = t('.text')

        def render?
          can?(:edit, resource)
        end
      end
    end
  end
end
