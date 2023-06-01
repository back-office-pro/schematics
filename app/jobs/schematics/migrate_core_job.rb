# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if Rails.cache.fetch('CORE_VERSION') == VERSION

      Core::SchemaDatasets::Migrate.call(schema_dataset:)
    end

    private

    def schema_dataset = ::SchemaDataset.new(
      data_version: VERSION,
      data: ::Tenant.schema.as_json
    )
  end
end
