# frozen_string_literal: true

module Schematics
  module Button
    module GoogleSignIn
      class Component < ApplicationComponent
        delegate :google_sign_in_feature_flag, to: ::Configuration, private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def data = { turbo: false }

        def path = '/auth/google_oauth2'

        def icon = :google

        def render? = google_sign_in_feature_flag
      end
    end
  end
end
