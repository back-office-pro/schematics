# frozen_string_literal: true

module Schematics
  module OnlineUsersCenter
    class Component < ApplicationComponent
      def users
        @users ||= ::User.online
      end
    end
  end
end
