# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    def perform = Application::ActiveStorage::Backup.call
  end
end
