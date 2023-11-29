# frozen_string_literal: true

module Schematics
  class CleanMessagesJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::Message
      .preload_all
      .read
      .destroy_by(versions: { created_at: ..DELAY.ago })
  end
end
