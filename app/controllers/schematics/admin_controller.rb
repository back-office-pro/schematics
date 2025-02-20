# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class AdminController < ApplicationController
    before_action :require_sudo!, only: :index

    def index
      authorize! :index, :admin
    end
  end
end
