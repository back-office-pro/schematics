# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      return if Tenant.schema.version == VERSION

      ::SchemaDataset
        .new(id: "core-#{VERSION}", data: Tenant.schema.as_json)
        .migrate
    end
  end
end
