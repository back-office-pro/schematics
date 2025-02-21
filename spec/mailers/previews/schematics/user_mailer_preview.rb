# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class UserMailerPreview < ActionMailer::Preview
    def new_account
      UserMailer.new_account(::User.take, url_options)
    end

    def password_reset
      UserMailer.password_reset(::User.take, url_options)
    end

    private

    def url_options = { host: 'localhost', port: 3000 }
  end
end
