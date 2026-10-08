# frozen_string_literal: true

module Schematics
  module Button
    module SSOSignIn
      class Component < ApplicationComponent
        delegate :sso_sign_in_feature_flag,
                 :sso_service_url,
                 :sso_cert_fingerprint,
                 to: '::Configuration',
                 private: true

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split',
          disabled: disabled?
        )

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg',
          turbo: false
        }

        def title = t('.text')

        def path = '/auth/saml'

        def icon = :fingerprint

        def form = { class: 'd-inline' }

        def tooltip_title
          t('.missing_sso_credentials') if disabled?
        end

        def render? = sso_sign_in_feature_flag

        private

        def disabled?
          sso_service_url.blank? || sso_cert_fingerprint.blank?
        end
      end
    end
  end
end
