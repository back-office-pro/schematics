# frozen_string_literal: true

module Schematics
  class RestoreDatabaseJob < ApplicationJob
    include Quietable
    queue_as :backups

    retry_on IOError, wait: :polynomially_longer, attempts: 5

    def perform(backup)
      ::Core::Backups::Restore.call(backup:)
      backup.state_ready!
    end
  end
end
