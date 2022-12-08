# frozen_string_literal: true

module Schematics
  class CleanSearchesJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform
      Schematics::Tenant.modules.each do |mod|
        mod::Search.destroy_by(created_at: ..DELAY.ago)
      end
    end
  end
end
