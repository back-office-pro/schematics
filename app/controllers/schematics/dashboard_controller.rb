# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    before_action :require_sudo!, only: :admin

    def admin
      authorize! :read, :admin_dashboard
    end

    def home
      @charts = ::Chart
                .with_string_translations
                .accessible_by_role(current_user.role)
                .excluding(::Chart.api)
                .then_tap { _1.in_order_of(:id, charts_preferences) if charts_preferences }
                .load_async
      @metrics = ::Metric
                 .with_string_translations
                 .accessible_by_role(current_user.role)
                 .then_tap { _1.in_order_of(:id, metrics_preferences) if metrics_preferences }
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

    def charts_preferences = current_user.preferences['charts']

    def metrics_preferences = current_user.preferences['metrics']
  end
end
