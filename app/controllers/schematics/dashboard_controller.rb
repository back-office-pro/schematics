# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    content_security_policy false, only: :home

    def home
      @charts = ::Chart.accessible_by_role(current_user.role)
      @stats = ::Stat.accessible_by_role(current_user.role)
    end

    def admin
      authorize! :read, :admin_dashboard
    end

    def read_notifications
      current_user.update!(read_notifications_at: ::Time.current)
    end
  end
end
