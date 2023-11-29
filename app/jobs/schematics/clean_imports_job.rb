# frozen_string_literal: true

module Schematics
  class CleanImportsJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Import
      .preload_all
      .not_state_in_progress
      .destroy_by(created_at: ..DELAY.ago)
  end
end
