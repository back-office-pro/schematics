# frozen_string_literal: true

module Schematics
  module Button
    module SsoSignIn
      class Component < ApplicationComponent
        delegate :sso_metadata_url, to: ::Configuration, private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = { turbo: false }

        def path = '/auth/saml'

        def icon = :fingerprint

        def form = { class: 'd-inline' }

        def render?
          sso_metadata_url.present?
        end
      end
    end
  end
end
