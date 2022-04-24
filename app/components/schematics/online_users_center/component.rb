# frozen_string_literal: true

module Schematics
  module OnlineUsersCenter
    class Component < ApplicationComponent
      def sessions
        @sessions ||= ::Session
                      .includes(:user)
                      .online
                      .order(updated_at: :desc)
      end
    end
  end
end
