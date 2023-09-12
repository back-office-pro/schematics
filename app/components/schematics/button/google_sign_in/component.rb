# frozen_string_literal: true

module Schematics
  module Button
    module GoogleSignIn
      class Component < ApplicationComponent
        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = { turbo: false }

        def method = :post

        def url = '/auth/google_oauth2'
      end
    end
  end
end
