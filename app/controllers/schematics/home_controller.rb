# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class HomeController < ApplicationController
    def index
      @dashboards = ::Dashboard
                    .preload_all
                    .accessible_by_role(current_user.role)
    end

    def destroy
      logout_user!
      redirect_to main_app.login_path, status: :see_other, notice: t('.success')
    end
  end
end
