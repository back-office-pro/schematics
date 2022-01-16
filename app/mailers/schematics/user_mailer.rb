# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    def password_reset(user)
      @user = user
      bootstrap_mail to: user.email
    end
  end
end
