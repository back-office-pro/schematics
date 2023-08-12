# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if ::Tenant.version == VERSION

      Core::Migrations::Migrate.call(migration: ::Migration.core)
    end
  end
end
