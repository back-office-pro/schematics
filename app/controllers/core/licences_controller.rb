# frozen_string_literal: true

module Core
  class LicencesController < Schematics::ResourcesController
    protected

    def resource_path = admin_path
  end
end
