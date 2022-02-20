# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Create
      include Interactable

      before do
        @user = ::User.find_by(email: context.email)
      end

      def call
        fail! unless @user

        @user.regenerate_password_reset_token
        @user.update!(updated_at: Time.current)
        UserMailer.password_reset(@user).deliver_later
      end
    end
  end
end
