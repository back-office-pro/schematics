# frozen_string_literal: true

module Schematics
  class CleanDraftsJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform = ::Draft
      .preload_all
      .delete_by(created_at: ..DELAY.ago)
  end
end
