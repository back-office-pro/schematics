# frozen_string_literal: true

module Schematics
  module Dashboard
    module Panel
      class Component < ApplicationComponent
        delegate :first?, to: :@iteration, private: true
        with_collection_parameter :dashboard

        def initialize(dashboard:, dashboard_iteration:)
          super
          @dashboard = dashboard
          @iteration = dashboard_iteration
        end

        def id = "dashboard-panel-#{@dashboard.id}"

        def css_classes = class_names(
          show: first?,
          active: first?
        )

        memoize def metrics = @dashboard
          .metrics
          .then { _1.in_order_of(:id, preferences_dashboard_metrics.concat(_1.ids).uniq) }
          .load_async

        memoize def charts = @dashboard
          .charts
          .then { _1.in_order_of(:id, preferences_dashboard_charts.concat(_1.ids).uniq) }
          .load_async

        memoize def rankings = @dashboard
          .rankings
          .then { _1.in_order_of(:id, preferences_dashboard_rankings.concat(_1.ids).uniq) }
          .load_async

        private

        def preferences_dashboard_metrics = Array(
          current_user
            .preferences_dashboard_metrics
            &.dig(@dashboard.id)
        )

        def preferences_dashboard_charts = Array(
          current_user
            .preferences_dashboard_charts
            &.dig(@dashboard.id)
        )

        def preferences_dashboard_rankings = Array(
          current_user
            .preferences_dashboard_rankings
            &.dig(@dashboard.id)
        )
      end
    end
  end
end
