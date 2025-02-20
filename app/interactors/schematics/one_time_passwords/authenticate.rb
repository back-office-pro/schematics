# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Authenticate
      include Interactable
      delegate :user, :resource_params, to: :context, private: true

      def call
        fail! unless user.authenticate_otp(otp_attempt)
      end

      private

      def otp_attempt = resource_params[:otp_attempt]
    end
  end
end
