# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    def new_account(user)
      @user = user
      @token = user.generate_token_for(:new_account)
      mail_to(user)
    end

    def password_reset(user)
      @user = user
      @token = user.generate_token_for(:password_reset)
      mail_to(user)
    end
  end
end
