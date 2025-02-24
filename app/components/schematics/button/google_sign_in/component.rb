# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module GoogleSignIn
      class Component < ApplicationComponent
        delegate :google_sign_in_feature_flag, to: 'current_module::Configuration', private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg',
          turbo: false
        }

        def title = t('.text')

        def path = '/auth/google_oauth2'

        def icon = :google

        def form = { class: 'd-inline' }

        def render? = google_sign_in_feature_flag
      end
    end
  end
end
