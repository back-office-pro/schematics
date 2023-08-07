# frozen_string_literal: true

module Schematics
  class CleanTasksJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform = ::Task
      .preload_all
      .not_state_pending
      .not_state_in_progress
      .destroy_by(created_at: ..DELAY.ago)
  end
end
