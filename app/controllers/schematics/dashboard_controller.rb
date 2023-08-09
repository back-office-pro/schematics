# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    def admin
      authorize! :read, :admin_dashboard
    end

    def home
      @charts = ::Chart
                .accessible_by_role(current_user.role)
                .excluding(::Chart.api)
                .then_tap { _1.in_order_of(:id, chart_preferences) if chart_preferences }
                .load_async
      @stats = ::Stat
               .accessible_by_role(current_user.role)
               .then_tap { _1.in_order_of(:id, stats_preferences) if stats_preferences }
               .load_async
    end

    def logout
      logout_user!
      redirect_to main_app.login_path, notice: t('.success')
    end

    def read_notifications
      current_user.update!(read_notifications_at: ::Time.current)
    end

    private

    def chart_preferences = current_user.preferences['charts']

    def stats_preferences = current_user.preferences['stats']
  end
end
