# frozen_string_literal: true

module Schematics
  class AdminController < ApplicationController
    before_action :require_sudo!, only: :index

    def index
      authorize! :index, :admin
      breadcrumb title, admin_path
      render Admin::Grid::Component.new
    end
  end
end
