# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module OnlineUsersCenter
      class Component < ApplicationComponent
        delegate :icon, to: 'current_module::User.entity'

        memoize def sessions = current_module::Session
          .with_user
          .with_user_avatar
          .active
          .order(:user_id, updated_at: :desc)
          .uniq(&:user)
      end
    end
  end
end
