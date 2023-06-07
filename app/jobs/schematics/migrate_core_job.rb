# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if Rails.cache.fetch('CORE_VERSION') == VERSION

      result = Core::SchemaDatasets::Migrate.call(schema_dataset:)
      Rails.cache.write('CORE_VERSION', VERSION) if result.success?
    end

    private

    def schema_dataset = ::SchemaDataset.new(data: ::Tenant.schema.as_json)
  end
end
