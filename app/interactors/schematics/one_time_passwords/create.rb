# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Create
      include Interactable
      delegate :user, :resource_params, to: :context, private: true

      def call
        fail! unless user.authenticate_otp(otp_attempt)

        user.update!(otp_last_at: ::Time.current)
      end

      private

      def otp_attempt = resource_params[:otp_attempt]
    end
  end
end
