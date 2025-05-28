# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class UserMailerPreview < ActionMailer::Preview
    def new_account
      user = ::User.take
      UserMailer.new_account(user.current_shard, user.id)
    end

    def password_reset
      user = ::User.take
      UserMailer.password_reset(user.current_shard, user.id)
    end
  end
end
