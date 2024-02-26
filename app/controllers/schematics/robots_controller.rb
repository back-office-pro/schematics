# frozen_string_literal: true

module Schematics
  class RobotsController < ApplicationController
    skip_before_action :authenticate_user!

    def index; end
  end
end
