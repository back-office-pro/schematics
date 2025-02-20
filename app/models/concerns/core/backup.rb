# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Backup
    def after_restore_database_event
      Schematics::RestoreBackupJob.perform_later(self)
    end
  end
end
