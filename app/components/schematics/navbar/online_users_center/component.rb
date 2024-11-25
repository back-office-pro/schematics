# frozen_string_literal: true

module Schematics
  module Navbar
    module OnlineUsersCenter
      class Component < ApplicationComponent
        delegate :icon, to: '::User.entity'

        memoize def sessions = ::Session
          .with_user
          .with_user_avatar
          .active
          .order(:user_id, updated_at: :desc)
          .uniq(&:user)
      end
    end
  end
end
