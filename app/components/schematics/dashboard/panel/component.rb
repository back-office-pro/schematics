# Copyright © 2025 Dev & Software. All rights reserved.
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

        def id = dom_id(@dashboard)

        def css_classes = class_names(
          show: first?,
          active: first?
        )

        def data(group)
          {
            controller: 'sortable',
            'sortable-group-value': "dashboard_#{group}_#{@dashboard.id}"
          }
        end

        memoize def metrics = @dashboard
          .metrics
          .with_string_translations
          .in_order_of(:id, metric_preferences, filter: false)
          .load_async

        memoize def charts = @dashboard
          .charts
          .with_string_translations
          .in_order_of(:id, chart_preferences, filter: false)
          .load_async

        memoize def rankings = @dashboard
          .rankings
          .with_string_translations
          .in_order_of(:id, ranking_preferences, filter: false)
          .load_async

        private

        def metric_preferences = current_user
          .preferences
          .fetch("dashboard_metrics_#{@dashboard.id}", [nil])

        def chart_preferences = current_user
          .preferences
          .fetch("dashboard_charts_#{@dashboard.id}", [nil])

        def ranking_preferences = current_user
          .preferences
          .fetch("dashboard_rankings_#{@dashboard.id}", [nil])
      end
    end
  end
end
