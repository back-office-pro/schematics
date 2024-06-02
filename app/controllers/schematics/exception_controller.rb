# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'schematics/jumbotron'

    def internal_server_error
      respond_with nil, status: :internal_server_error
    end

    def maintenance_mode
      respond_with nil, status: :service_unavailable
    end

    def unsupported_browser
      respond_with nil, status: :not_acceptable
    end

    def not_found
      respond_with nil, status: :not_found
    end

    def schema_error
      respond_with nil, status: :not_acceptable
    end
  end
end
