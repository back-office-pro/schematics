# frozen_string_literal: true

module Schematics
  module Button
    module GoogleSignIn
      class Component < ApplicationComponent
        def css_classes = %w[btn btn-sm btn-icon-split float-end]

        def data = { turbo_method: :post }

        def path = '/auth/google_oauth2'
      end
    end
  end
end
