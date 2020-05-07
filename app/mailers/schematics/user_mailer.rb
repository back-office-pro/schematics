module Schematics
  class UserMailer < ApplicationMailer
    def password_reset(user)
      @user = user
      make_bootstrap_mail to: user.email
    end
  end
end
