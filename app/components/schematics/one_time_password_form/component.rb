# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module OneTimePasswordForm
    class Component < ApplicationComponent
      delegate :root_path, :one_time_passwords_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :company_name, to: 'current_module::Configuration', private: true

      alias model current_user

      def url = one_time_passwords_path

      def scope = :user

      def qr_code
        ::RQRCode::QRCode.new(provisioning_uri) if provisioning_uri
      end

      private

      def provisioning_uri
        current_user.provisioning_uri(nil, issuer: company_name)
      end
    end
  end
end
