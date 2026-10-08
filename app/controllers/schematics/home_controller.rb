# frozen_string_literal: true

module Schematics
  class HomeController < ApplicationController
    def index
      render Dashboard::Component.new
    end

    def destroy
      logout_user!
      redirect_to main_app.login_path, status: :see_other, notice: t('.success')
    end
  end
end
