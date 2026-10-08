# frozen_string_literal: true

module Schematics
  module Button
    module GoogleSignIn
      class Component < ApplicationComponent
        delegate :google_sign_in_feature_flag,
                 :google_oauth_client_id,
                 :google_oauth_client_secret,
                 to: '::Configuration', private: true

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split',
          'ms-1',
          disabled: disabled?
        )

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg',
          turbo: false
        }

        def title = t('.text')

        def path = '/auth/google_oauth2'

        def icon = :google

        def form = { class: 'd-inline' }

        def tooltip_title
          t('.missing_oauth_credentials') if disabled?
        end

        def render? = google_sign_in_feature_flag

        private

        def disabled?
          google_oauth_client_id.blank? || google_oauth_client_secret.blank?
        end
      end
    end
  end
end
