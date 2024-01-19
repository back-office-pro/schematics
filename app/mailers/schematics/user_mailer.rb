# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    def new_account(user)
      @token = user.generate_token_for(:password_reset)
      mail_to(user)
    end

    def password_reset(user)
      @token = user.generate_token_for(:password_reset)
      mail_to(user)
    end
  end
end
