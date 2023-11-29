# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    queue_as :backups

    def perform = Core::Migrations::Backup.call(force: true)
  end
end
