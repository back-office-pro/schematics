# frozen_string_literal: true

module Schematics
  module OnlineUsersCenter
    class Component < ApplicationComponent
      def sessions
        @sessions ||= ::Session
                      .with_user_avatar
                      .online
                      .order(updated_at: :desc)
      end
    end
  end
end
