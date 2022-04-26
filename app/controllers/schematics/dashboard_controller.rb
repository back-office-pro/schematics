# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    def home
      @charts = ::Chart.accessible_by_role(current_user.role).load_async
      @stats = ::Stat.accessible_by_role(current_user.role).load_async
    end

    def admin
      authorize! :read, :admin_dashboard
      @licence = ::Licence.instance
    end

    def read_notifications
      current_user.update!(read_notifications_at: ::Time.current)
    end
  end
end
