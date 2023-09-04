# frozen_string_literal: true

module Schematics
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        option :resource
        option :compact, default: proc { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def icon_class
          'fa-fw' if compact?
        end

        def data = {
          turbo_frame: '_top',
          controller: ('tooltip' if compact?)
        }.compact

        def render?
          can?(:edit, resource)
        end

        def title
          return unless compact?

          t('.text')
        end
      end
    end
  end
end
