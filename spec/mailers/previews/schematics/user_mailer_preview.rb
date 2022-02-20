# frozen_string_literal: true

module Schematics
  class UserMailerPreview < ActionMailer::Preview
    def new_account
      UserMailer.new_account(::User.first)
    end

    def password_reset
      UserMailer.password_reset(::User.first)
    end
  end
end
