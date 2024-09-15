# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    include Quietable
    queue_as :backups

    retry_on IOError, wait: :polynomially_longer, attempts: 5

    def perform
      backup = ::Backup.new
      backup.file.attach(**Core::Backups::Create.call.to_h)
      backup.save!
    end
  end
end
