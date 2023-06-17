# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if Rails.cache.fetch('CORE_VERSION') == VERSION

      result = Core::Migrations::Migrate.call(migration:)
      Rails.cache.write('CORE_VERSION', VERSION) if result.success?
    end

    private

    def migration = ::Migration.new(data: ::Tenant.schema.as_json)
  end
end
