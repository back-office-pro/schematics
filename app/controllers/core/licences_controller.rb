# frozen_string_literal: true

module Core
  module LicencesController
    extend ActiveSupport::Concern

    def trigger_redirect_path = admin_path
  end
end
