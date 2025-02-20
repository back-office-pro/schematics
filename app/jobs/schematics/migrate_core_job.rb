# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    include Quietable
    queue_as :critical

    def perform
      return if ::Documentation.last.core_version == VERSION

      Core::Migrations::Migrate.call(migration: ::Migration.core)
      FileUtils.touch Rails.root.join('tmp/restart.txt')
    end
  end
end
