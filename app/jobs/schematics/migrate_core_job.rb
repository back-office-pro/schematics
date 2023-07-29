# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if ::Tenant.version == VERSION

      Core::Migrations::Migrate.call(migration:)
    end

    private

    def migration = ::Migration.new(data: ::Tenant.schema.as_json)
  end
end
