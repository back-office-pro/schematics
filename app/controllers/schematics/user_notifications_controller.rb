# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class UserNotificationsController < ApplicationController
    def update
      current_user.update!(read_notifications_at: ::Time.current)
    end
  end
end
