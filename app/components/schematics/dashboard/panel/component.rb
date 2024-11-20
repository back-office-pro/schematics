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
          .then { _1.in_order_of(:id, metric_preferences.concat(_1.ids).uniq) }
          .load_async

        memoize def charts = @dashboard
          .charts
          .with_string_translations
          .then { _1.in_order_of(:id, chart_preferences.concat(_1.ids).uniq) }
          .load_async

        memoize def rankings = @dashboard
          .rankings
          .with_string_translations
          .then { _1.in_order_of(:id, ranking_preferences.concat(_1.ids).uniq) }
          .load_async

        private

        def metric_preferences = current_user
          .preferences
          .fetch("dashboard_metrics_#{@dashboard.id}", [])

        def chart_preferences = current_user
          .preferences
          .fetch("dashboard_charts_#{@dashboard.id}", [])

        def ranking_preferences = current_user
          .preferences
          .fetch("dashboard_rankings_#{@dashboard.id}", [])
      end
    end
  end
end
