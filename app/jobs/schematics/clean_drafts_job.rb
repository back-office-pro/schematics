# frozen_string_literal: true

module Schematics
  class CleanDraftsJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform = Core::Draft
      .preload_all
      .destroy_by(created_at: ..DELAY.ago)
  end
end
