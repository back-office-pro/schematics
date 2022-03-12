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
        fail!(message: '.expired') if expired?
        fail! unless @user.update(@params)
      end

      private

      def expired?
        return false unless @user.password_digest

        2.hours.ago.after?(@user.reset_password_sent_at)
      end
    end
  end
end
