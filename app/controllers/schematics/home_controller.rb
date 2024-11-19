# frozen_string_literal: true

module Schematics
  class HomeController < ApplicationController
    def index
      @charts = ::Chart
                .with_string_translations
                .accessible_by_role(current_user.role)
                .excluding(::Chart.api)
                .then { _1.in_order_of(:id, current_user.preferences_charts.concat(_1.ids).uniq) }
                .load_async
      @metrics = ::Metric
                 .with_string_translations
                 .accessible_by_role(current_user.role)
                 .then { _1.in_order_of(:id, current_user.preferences_metrics.concat(_1.ids).uniq) }
                 .load_async
      @rankings = ::Ranking
                  .with_string_translations
                  .accessible_by_role(current_user.role)
                  .then { _1.in_order_of(:id, current_user.preferences_rankings.concat(_1.ids).uniq) } # rubocop:disable Layout/LineLength
                  .load_async
    end

    def destroy
      logout_user!
      redirect_to main_app.login_path, notice: t('.success')
    end
  end
end
