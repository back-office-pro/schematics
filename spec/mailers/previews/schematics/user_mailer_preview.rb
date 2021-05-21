# frozen_string_literal: true

module Schematics
  class UserMailerPreview < ActionMailer::Preview
    def password_reset
      UserMailer.password_reset(User.first)
    end
  end
end
