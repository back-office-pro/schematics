# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module DestroyOtp
      class Component < ApplicationComponent
        delegate :one_time_passwords_path, to: 'Schematics::Engine.routes.url_helpers'

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split]

        def form = { class: 'd-inline' }
      end
    end
  end
end
