module Schematics
  class DashboardController < ApplicationController
    def home
    end

    def chart
      render json: SCHEMA.charts[params[:id].to_i - 1]
    end
  end
end
