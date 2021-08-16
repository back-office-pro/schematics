# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    def home; end

    def admin; end

    def chart
      render json: Schema.instance.charts[params[:id].to_i.pred]
    end

    def read_notifications
      current_user.update(updated_at: Time.current)
    end
  end
end
