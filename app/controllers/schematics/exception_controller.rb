# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    layout 'schematics/jumbotron', except: :not_found

    def internal_server_error
      respond_with nil, status: :internal_server_error
    end

    def maintenance_mode
      respond_with nil, status: :service_unavailable
    end

    def not_found
      respond_with nil, status: :not_found
    end

    def schema_error
      respond_with nil, status: :unknown_error
    end
  end
end
