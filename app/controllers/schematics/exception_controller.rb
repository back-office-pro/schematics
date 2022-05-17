# frozen_string_literal: true

module Schematics
  class ExceptionController < ApplicationController
    layout 'schematics/auth', except: :not_found

    def internal_server_error
      respond_to do |format|
        format.html
        format.json { head :internal_server_error }
      end
    end

    def not_found
      respond_to do |format|
        format.html
        format.json { head :not_found }
      end
    end

    def schema_error
      respond_to do |format|
        format.html
        format.json { head :service_unavailable }
      end
    end
  end
end
