# frozen_string_literal: true

module Schematics
  class CleanComparisonsJob < ApplicationJob
    DELAY = 30.days.freeze
    queue_as :cleanups

    def perform = ::Comparison
      .preload_all
      .delete_by(created_at: ..DELAY.ago)
  end
end
