module Schematics
  class DashboardController < ApplicationController
    def home; end

    def chart
      render json: Schema.instance.charts[params[:id].to_i - 1]
    end

    def read_notifications
      current_user.touch # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
