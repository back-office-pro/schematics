# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        option :path, default: proc { '' }
        option :data, optional: true
        option :compact, default: proc { false }

        def compact? = compact

        def css_classes = [
          'btn',
          'btn-danger',
          'btn-sm',
          { 'btn-icon-split': !compact? }
        ]

        def icon_class
          'fa-fw' if compact?
        end
      end
    end
  end
end
