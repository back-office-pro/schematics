# frozen_string_literal: true

module Schematics
  class CleanApiRequestsJob < ApplicationJob
    DELAY = 1.year.freeze

    def perform
      ::ApiRequest.destroy_by(created_at: ..DELAY.ago)
    end
  end
end
