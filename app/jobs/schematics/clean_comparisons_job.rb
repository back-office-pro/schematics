# frozen_string_literal: true

module Schematics
  class CleanComparisonsJob < ApplicationJob
    DELAY = 30.days.freeze

    def perform
      ::Comparison.destroy_by(created_at: ..DELAY.ago)
    end
  end
end
