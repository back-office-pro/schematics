# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    queue_as :backups

    retry_on IOError, wait: :polynomially_longer, attempts: 5 do |_job, error|
      Rollbar.error(error)
    end

    def perform = Core::Migrations::Backup.call(force: true)
  end
end
