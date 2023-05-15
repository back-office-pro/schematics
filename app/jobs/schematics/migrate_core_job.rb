# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if ::Tenant.schema.version == VERSION

      Core::SchemaDatasets::Migrate.call(schema_dataset:)
    end

    private

    def schema_dataset = ::SchemaDataset.new(id: "core-#{VERSION}", data: ::Tenant.schema.as_json)
  end
end
