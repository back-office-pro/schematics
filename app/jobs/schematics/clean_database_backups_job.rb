# frozen_string_literal: true

module Schematics
  class CleanDatabaseBackupsJob < ApplicationJob
    DELAY = 30.days.freeze

    queue_as :cleanups
    delegate :exists?, to: ::ActiveStorage::Blob, private: true

    def perform
      return unless exists?(filename: 'db.dump', created_at: Date.current.all_day)

      ::ActiveStorage::Blob
        .preload_all
        .delete_by(filename: 'db.dump', created_at: ..DELAY.ago)
    end
  end
end
