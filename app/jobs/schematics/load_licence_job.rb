# frozen_string_literal: true

module Schematics
  class LoadLicenceJob < ApplicationJob
    def perform
      Schematics::Tenant.modules.each do |mod|
        mod::Licence.instance.load!
      end
    end
  end
end
