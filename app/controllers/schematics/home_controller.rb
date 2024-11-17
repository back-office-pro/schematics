# frozen_string_literal: true

module Schematics
  class HomeController < ApplicationController
    def index
      @dashboards = ::Dashboard
                    .preload_all
                    .accessible_by_role(current_user.role)
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
