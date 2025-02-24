# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Import
      class Component < ApplicationComponent
        delegate :human_name_plural, to: :model_class
        delegate :icon, to: 'current_module::Import.entity'
        option :model_class

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text', human_name_plural:)

        def css_classes = %w[btn btn-sm btn-icon-split bg-body-tertiary ms-1]

        def path = new_import_resource_path(model_class)

        def render?
          can?(:import, model_class)
        end
      end
    end
  end
end
