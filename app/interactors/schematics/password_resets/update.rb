# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Update
      include Interactable

      before do
        @params = context.user_params.merge(password_reset_token: nil)
        @user = context.user
      end

      def call
        fail! if expired?
        fail!(message: '.error') unless @user.update(@params)
      end

      private

      def expired?
        @user.password_digest && @user.reset_password_sent_at < 2.hours.ago
      end
    end
  end
end
