# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    include Quietable
    queue_as :backups

    retry_on IOError, wait: :polynomially_longer, attempts: 5

    def perform
      ::Backup.create!(file: Core::Backups::Create.call.file)
    end
  end
end
