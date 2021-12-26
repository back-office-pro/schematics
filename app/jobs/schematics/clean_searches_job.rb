# frozen_string_literal: true

module Schematics
  class CleanSearchesJob < ApplicationJob
    def perform
      Search.destroy_by(created_at: ..1.year.ago)
    end
  end
end
