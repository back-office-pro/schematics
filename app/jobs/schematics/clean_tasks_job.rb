# frozen_string_literal: true

module Schematics
  class CleanTasksJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Task
      .preload_all
      .not_state_pending
      .not_state_in_progress
      .where(created_at: ..DELAY.ago)
      .in_batches
      .destroy_all
  end
end
