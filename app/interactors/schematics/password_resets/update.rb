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
        fail!(message: '.expired') if @user.password_reset_token_expired?
        fail! unless @user.update(@params)
      end
    end
  end
end
