module Schematics
  module PasswordResets
    class Create
      include Interactor

      before do
        @user = User.find_by_email(context.email)
      end

      def call
        if @user
          context.message = ".success"
          @user.regenerate_password_reset_token
          @user.touch
          UserMailer.password_reset(@user).deliver_later
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
