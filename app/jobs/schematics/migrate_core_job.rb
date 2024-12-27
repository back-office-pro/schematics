# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    include Quietable
    queue_as :critical

    def perform
      return if ::Tenant.version == VERSION

      Core::Migrations::Migrate.call(migration: ::Migration.core)
    end
  end
end
