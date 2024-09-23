# frozen_string_literal: true

class Backup < Schematics::ApplicationRecord
  def after_restore_database_event
    Schematics::RestoreDatabaseJob.perform_later(self)
  end
end
