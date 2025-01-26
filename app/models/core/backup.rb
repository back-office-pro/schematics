# frozen_string_literal: true

class ::Backup < Schematics::ApplicationRecord
  def after_restore_database_event
    Schematics::RestoreBackupJob.perform_later(self)
  end
end
