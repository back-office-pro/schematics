# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Rollback
      include Interactor::Organizer

      organize Copy,
               Generate,
               MigrateDatabase,
               RestoreBackup,
               CleanSearchIndexes,
               Reload,
               RebuildSearchIndexes,
               CleanDocumentation,
               GenerateFixture,
               Commit
    end
  end
end
