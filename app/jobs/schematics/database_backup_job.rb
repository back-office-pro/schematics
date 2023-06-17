# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    def perform = Core::Migrations::Backup.call(force: true)
  end
end
