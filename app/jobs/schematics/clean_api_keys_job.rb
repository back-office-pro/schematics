# frozen_string_literal: true

module Schematics
  class CleanApiKeysJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::ApiKey
      .preload_all
      .not_active
      .destroy_by(expires_at: ..DELAY.ago)
  end
end
