# frozen_string_literal: true

module Schematics
  class CleanSessionsJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform = Core::Session
      .preload_all
      .destroy_by(created_at: ..DELAY.ago)
  end
end
