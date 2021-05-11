module Schematics
  class DashboardController < ApplicationController
    def home; end

    def chart
      render json: Schema.instance.charts[params[:id].to_i - 1]
    end

    def read_notifications
      current_user.touch # rubocop:disable Rails/SkipsModelValidations
    end

    def toggle_sidebar
      current_user.update(preferences_sidebar_toggled: !current_user.preferences_sidebar_toggled)
    end

    def toggle_theme
      new_theme = current_user.preferences_theme == 'light' ? 'dark' : 'light'
      current_user.update(preferences_theme: new_theme)
    end
  end
end
