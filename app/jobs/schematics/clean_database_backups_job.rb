# frozen_string_literal: true

module Schematics
  class CleanDatabaseBackupsJob < ApplicationJob
    OFFSET = 7
    queue_as :cleanups

    def perform = ::ActiveStorage::Blob
      .preload_all
      .where(filename: 'db.dump')
      .order(created_at: :desc)
      .offset(OFFSET)
      .delete_all
  end
end
