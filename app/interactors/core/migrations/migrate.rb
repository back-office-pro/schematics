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
               Cache,
               Reload,
               RebuildSearchIndexes,
               GenerateDocumentation,
               GenerateFixture,
               Commit
    end
  end
end
