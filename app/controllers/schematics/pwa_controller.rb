# frozen_string_literal: true

module Schematics
  class PwaController < ApplicationController
    skip_before_action :authenticate_user!

    def service_worker; end

    def manifest; end
  end
end
