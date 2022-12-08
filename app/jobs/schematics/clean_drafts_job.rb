# frozen_string_literal: true

module Schematics
  class CleanDraftsJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform
      Schematics::Tenant.modules.each do |mod|
        mod::Draft.destroy_by(created_at: ..DELAY.ago)
      end
    end
  end
end
