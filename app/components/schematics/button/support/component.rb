# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Support
      class Component < ApplicationComponent
        option :wrapper_css_classes, default: -> { 'btn btn-primary btn-sm btn-icon-split' }
        option :icon_css_classes, optional: true

        class << self
          def dropdown_item = new(
            wrapper_css_classes: 'dropdown-item',
            icon_css_classes: 'me-3'
          )
        end
      end
    end
  end
end
