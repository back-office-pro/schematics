# frozen_string_literal: true

module Schematics
  module Button
    module SsoSignIn
      class Component < ApplicationComponent
        delegate :sso_service_url,
                 :sso_cert_fingerprint,
                 to: ::Configuration,
                 private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = { turbo: false }

        def path = '/auth/saml'

        def icon = :fingerprint

        def form = { class: 'd-inline' }

        def render?
          sso_service_url.present? && sso_cert_fingerprint.present?
        end
      end
    end
  end
end
