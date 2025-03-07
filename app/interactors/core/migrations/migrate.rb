# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Migrate
      include Interactor::Organizer

      organize Copy,
               Generate,
               GenerateBackup,
               MigrateDatabase,
               CleanSearchIndexes,
               Reload,
               RebuildSearchIndexes,
               GenerateDocumentation,
               GenerateFixture
    end
  end
end
