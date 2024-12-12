# frozen_string_literal: true

module Schematics
  class RestoreBackupJob < ApplicationJob
    include Quietable
    queue_as :backups

    discard_on ActiveStorage::FileNotFoundError

    def perform(backup)
      ::Core::Backups::Restore.call(backup: backup.file, clean: true)
      backup.reload.state_ready!
    end
  end
end
