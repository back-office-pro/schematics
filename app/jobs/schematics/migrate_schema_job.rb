# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    queue_as :migrations

    def perform(migration)
      PaperTrail.request(enabled: false) do
        migration.finalize! Core::Migrations::Migrate.call(migration:).failure?
      end
    end
  end
end
