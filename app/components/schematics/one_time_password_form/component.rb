# frozen_string_literal: true

module Schematics
  module OneTimePasswordForm
    class Component < ApplicationComponent
      delegate :root_path, :one_time_password_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :company_name, to: ::Configuration, private: true
      delegate :provisioning_uri, to: :current_user, private: true

      alias model current_user

      def url = one_time_password_path

      def qr_code = ::RQRCode::QRCode.new provisioning_uri(nil, issuer: company_name)
    end
  end
end
