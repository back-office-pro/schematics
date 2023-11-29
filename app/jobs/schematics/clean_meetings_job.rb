# frozen_string_literal: true

module Schematics
  class CleanMeetingsJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Meeting
      .preload_all
      .destroy_by(end_at: ..DELAY.ago)
  end
end
