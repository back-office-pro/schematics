# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        option :path, default: -> { '' }
        option :data, default: -> { {} }
        option :compact, default: -> { false }

        def compact? = compact

        def data
          return super unless compact?

          super.merge(controller: 'tooltip')
        end

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?
        )

        def title = t('.title')
      end
    end
  end
end
