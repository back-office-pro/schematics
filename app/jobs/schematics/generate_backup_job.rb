# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateBackupJob < ApplicationJob
    include Quietable

    queue_as :critical

    retry_on IOError, wait: :polynomially_longer, attempts: 5

    def perform
      ::Backup.create!(file: Core::Backups::Create.call.file)
    end
  end
end
