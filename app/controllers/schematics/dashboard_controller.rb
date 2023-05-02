# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    def admin
      authorize! :read, :admin_dashboard
    end

    def home
      @charts = Core::Chart.accessible_by_role(current_user.role).load_async
      @stats = Core::Stat.accessible_by_role(current_user.role).load_async
    end

    def logout
      logout_user!
      redirect_to main_app.login_path, notice: t('.success')
    end

    def read_notifications
      current_user.update!(read_notifications_at: ::Time.current)
    end
  end
end
