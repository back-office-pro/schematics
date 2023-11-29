# frozen_string_literal: true

module Schematics
  class CleanSearchesJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Search
      .preload_all
      .delete_by(created_at: ..DELAY.ago)
  end
end
