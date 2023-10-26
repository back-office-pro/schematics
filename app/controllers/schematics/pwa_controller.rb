# frozen_string_literal: true

module Schematics
  class PwaController < ApplicationController
    skip_before_action :authenticate_user!

    def service_worker; end

    def manifest
      @logo = ::Configuration.with_attached_company_logo.company_logo
    end
  end
end
