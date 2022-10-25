# frozen_string_literal: true

module Schematics
  class DatabaseBackupJob < ApplicationJob
    def perform = SchemaDatasets::Backup.call(force: true)
  end
end
