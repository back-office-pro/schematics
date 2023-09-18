# frozen_string_literal: true

module Schematics
  module Button
    module SsoSignIn
      class Component < ApplicationComponent
        delegate :sso_sign_in_feature_flag, to: ::Configuration, private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = { turbo: false }

        def path = '/auth/saml'

        def icon = :fingerprint

        def render? = sso_sign_in_feature_flag
      end
    end
  end
end
