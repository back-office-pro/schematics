# frozen_string_literal: true

module Schematics
  class RestoreBackupJob < ApplicationJob
    include Quietable
    queue_as :backups

    def perform(backup)
      ::Core::Backups::Restore.call(backup: backup.file)
      backup.state_ready!
    end
  end
end
