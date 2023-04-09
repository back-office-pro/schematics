# frozen_string_literal: true

module Schematics
  class CleanDatabaseBackupsJob < ApplicationJob
    DELAY = 30.days.freeze

    def perform = ::ActiveStorage::Blob
      .preload_all
      .destroy_by(filename: 'db.dump', created_at: ..DELAY.ago)
  end
end
