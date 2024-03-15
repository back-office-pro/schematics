# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    queue_as :migrations

    def perform
      return if ::Tenant.version == VERSION

      Core::Migrations::CopyAndMigrate.call(migration: ::Migration.core)
    end
  end
end
