# frozen_string_literal: true

module Schematics
  class MigrateCoreJob < ApplicationJob
    def perform
      `rails schematics:install:migrations`
      ActiveRecord::Base
        .connection
        .migration_context
        .migrate
    end
  end
end
