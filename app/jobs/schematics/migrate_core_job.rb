# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    include MultiShardable
    include Quietable
    queue_as :critical

    def perform = for_each_shards do
      return if ::Documentation.last.core_version == VERSION

      Core::Migrations::Migrate.call(migration: ::Migration.core)
    end
  end
end
