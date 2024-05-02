# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    queue_as :migrations

    def perform
      return if ::Tenant.version == VERSION

      PaperTrail.request(enabled: false) do
        Core::Migrations::Migrate.call(migration: ::Migration.core)
      end
    end
  end
end
