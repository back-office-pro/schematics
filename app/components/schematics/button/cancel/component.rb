# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        option :path, default: -> { '' }
        option :data, optional: true
        option :compact, default: -> { false }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?
        )

        def icon_class
          'fa-fw' if compact?
        end
      end
    end
  end
end
