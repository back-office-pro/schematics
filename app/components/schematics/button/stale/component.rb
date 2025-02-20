# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Stale
      class Component < ApplicationComponent
        delegate :version_path, to: 'Schematics::Engine.routes.url_helpers'
        option :resource

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split ms-1]

        def last_version = resource
          .paper_trail_versions
          .last

        def render?
          resource.errors.of_kind?(:base, :stale) && last_version
        end
      end
    end
  end
end
