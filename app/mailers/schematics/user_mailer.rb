# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    def new_account(user)
      @user = user
      bootstrap_mail to: email_address_with_name(user.email, user.full_name)
    end

    def password_reset(user)
      @user = user
      bootstrap_mail to: email_address_with_name(user.email, user.full_name)
    end
  end
end
