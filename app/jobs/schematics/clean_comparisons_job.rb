# frozen_string_literal: true

module Schematics
  class CleanComparisonsJob < ApplicationJob
    def perform
      Comparison.destroy_by(created_at: ..30.days.ago)
    end
  end
end
