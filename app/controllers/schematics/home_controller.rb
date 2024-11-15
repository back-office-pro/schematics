# frozen_string_literal: true

module Schematics
  class HomeController < ApplicationController
    def show # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      @dashboards =
        ::Dashboard
          .preload_all
          .accessible_by_role(current_user.role)
      @dashboard = @dashboards.where(id: current_user.preferences_dashboard) || @dashboards.first
      @metrics =
        @dashboard
          &.metrics
          &.then { _1.in_order_of(:id, current_user.preferences_metrics.concat(_1.ids).uniq) }
          &.load_async
      @charts =
        @dashboard
          &.charts
          &.then { _1.in_order_of(:id, current_user.preferences_charts.concat(_1.ids).uniq) }
          &.load_async
      @rankings =
        @dashboard
          &.rankings
          &.then { _1.in_order_of(:id, current_user.preferences_rankings.concat(_1.ids).uniq) }
          &.load_async
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
