# frozen_string_literal: true

module Schematics
  class RestoreBackupJob < ApplicationJob
    include Quietable

    queue_as :critical

    discard_on ActiveStorage::FileNotFoundError

    after_discard do |job|
      PaperTrail.request(enabled: false) do
        suppress(ActiveRecord::RecordNotFound) do
          job.arguments.first.reload.state_error!
        end
      end
    end

    def perform(backup)
      Core::Backups::Restore.call(backup: backup.file, clean: true)
      backup.reload.state_ready!
    end
  end
end
