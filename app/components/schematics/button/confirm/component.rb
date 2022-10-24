# frozen_string_literal: true

module Schematics
  module Button
    module Confirm
      class Component < ApplicationComponent
        option :compact, default: proc { false }

        def compact? = compact

        def css_classes = [
          'btn',
          'btn-primary',
          'btn-sm',
          { 'btn-icon-split': !compact? },
          { 'me-2': !compact? },
          { 'mx-1': compact? }
        ]

        def icon_class
          'fa-fw' if compact?
        end
      end
    end
  end
end
