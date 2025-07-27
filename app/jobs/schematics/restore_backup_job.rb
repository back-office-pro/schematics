# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RestoreBackupJob < ApplicationJob
    include Shardable
    include Quietable

    queue_as :critical

    discard_on ActiveStorage::FileNotFoundError

    after_discard do |job|
      PaperTrail.request(enabled: false) do
        ::Backup.find_by(id: job.arguments.second).try(:state_error!)
      end
    end

    def perform(_shard, backup_id)
      backup = ::Backup.find(backup_id)
      Core::Backups::Restore.call(backup: backup.file, clean: true)
      backup.reload.state_ready!
    end
  end
end
