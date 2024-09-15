# frozen_string_literal: true

class Backup < Schematics::ApplicationRecord
  def after_restore
    ::Core::Backups::Restore.call(backup: file)
  end
end
