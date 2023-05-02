# frozen_string_literal: true

module Schematics
  class CleanSearchesJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform = Core::Search
      .preload_all
      .destroy_by(created_at: ..DELAY.ago)
  end
end
