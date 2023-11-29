# frozen_string_literal: true

module Schematics
  class CleanApiRequestsJob < ApplicationJob
    DELAY = 1.year.freeze
    queue_as :cleanups

    def perform = ::ApiRequest
      .preload_all
      .delete_by(created_at: ..DELAY.ago)
  end
end
