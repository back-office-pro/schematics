# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Sessions
    class Omniauthenticate
      include Schematics::Interactable
      delegate :resource_params, to: :context, private: true
      delegate :otp_enabled?, :generate_token_for, to: :user, allow_nil: true, private: true

      def call
        return unless resource_params in OmniAuth::AuthHash::InfoHash

        context.user = user
        context.otp_token = otp_token
      end

      private

      memoize def user = ::User.find_by(email:)

      def otp_token
        generate_token_for(:one_time_password) if otp_enabled?
      end

      def email = resource_params[:email]
    end
  end
end
