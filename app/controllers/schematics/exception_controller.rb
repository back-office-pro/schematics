# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    allow_unauthenticated_access
    layout 'schematics/jumbotron'

    def internal_server_error
      respond_with nil, status: :internal_server_error
    end

    def maintenance_mode
      respond_with nil, status: :service_unavailable
    end

    def not_found
      respond_with nil, status: :not_found
    end

    def offline; end
  end
end
