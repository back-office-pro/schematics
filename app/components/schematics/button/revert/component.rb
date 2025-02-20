# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Revert
      class Component < ApplicationComponent
        delegate :revert_version_path, to: 'Schematics::Engine.routes.url_helpers'
        option :version

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def render?
          can?(:revert, version)
        end
      end
    end
  end
end
