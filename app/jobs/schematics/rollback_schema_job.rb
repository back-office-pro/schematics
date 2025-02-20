# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RollbackSchemaJob < ApplicationJob # rubocop:disable Obsession/Rails/ServiceName
    include Quietable
    queue_as :critical

    def perform(migration)
      return if migration.state_generating?
      return if migration.state_in_progress?

      migration.finalize!(Core::Migrations::Rollback.call(migration:).failure?)
    end
  end
end
