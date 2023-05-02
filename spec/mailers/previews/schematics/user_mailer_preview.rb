# frozen_string_literal: true

module Schematics
  class UserMailerPreview < ActionMailer::Preview
    def new_account
      UserMailer.new_account(Core::User.first)
    end

    def password_reset
      UserMailer.password_reset(Core::User.first)
    end
  end
end
