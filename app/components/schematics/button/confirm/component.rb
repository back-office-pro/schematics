# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Confirm
      class Component < ApplicationComponent
        option :compact, default: -> { false }

        def data
          { controller: 'tooltip' } if compact?
        end

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split': !compact?,
          'me-2': !compact?,
          'mx-1': compact?
        )

        def title = t('schematics.application.button.confirm')
      end
    end
  end
end
