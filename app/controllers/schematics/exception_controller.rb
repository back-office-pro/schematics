# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    allow_unauthenticated_access
    layout 'schematics/jumbotron'

    def internal_server_error
      respond_to do |format|
        format.html
        format.json { head :internal_server_error }
      end
    end

    def maintenance_mode
      respond_to do |format|
        format.html
        format.json { head :service_unavailable }
      end
    end

    def not_found
      respond_to do |format|
        format.html
        format.json { head :not_found }
      end
    end

    def offline; end
  end
end
