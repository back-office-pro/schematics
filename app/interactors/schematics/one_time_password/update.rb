# frozen_string_literal: true

module Schematics
  module OneTimePassword
    class Update
      include Interactable
      delegate :user, :resource_params, to: :context, private: true

      def call
        fail! unless user.authenticate_otp(otp_attempt)

        user.update!(otp_enabled: true)
      end

      private

      def otp_attempt = resource_params[:otp_attempt]
    end
  end
end
