# frozen_string_literal: true

module Schematics
  module Button
    module DestroyOtp
      class Component < ApplicationComponent
        delegate :one_time_password_path, to: 'Schematics::Engine.routes.url_helpers'
        delegate :otp_enabled?, to: :current_user, private: true

        def data = { controller: 'tooltip', 'bs-custom-class': 'responsive-button-tooltip' }

        def title = t('.text')

        def css_classes = %w[btn btn-danger btn-sm btn-icon-split]

        def form = { class: 'd-inline' }

        alias render? otp_enabled?
      end
    end
  end
end
