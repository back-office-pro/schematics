# frozen_string_literal: true

module Schematics
  class CleanMessagesJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Message
      .preload_all
      .read
      .where(paper_trail_versions: { created_at: ..DELAY.ago })
      .in_batches
      .destroy_all
  end
end
