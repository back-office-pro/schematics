# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    def new_account(user)
      @user = user
      make_bootstrap_mail to: user.email
    end

    def password_reset(user)
      @user = user
      bootstrap_mail to: user.email
    end
  end
end
