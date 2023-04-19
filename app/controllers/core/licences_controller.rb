# frozen_string_literal: true

module Core
  module LicencesController
    extend ActiveSupport::Concern

    def resource_path = admin_path
  end
end
