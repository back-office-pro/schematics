# frozen_string_literal: true

module Schematics
  class RollbackSchemaJob < ApplicationJob # rubocop:disable Obsession/Rails/ServiceName
    include Quietable
    queue_as :migrations

    def perform(migration)
      return if migration.state_generating?
      return if migration.state_in_progress?

      migration.finalize!(Core::Migrations::Rollback.call(migration:).failure?)
    end
  end
end
