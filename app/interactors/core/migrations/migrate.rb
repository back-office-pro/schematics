# frozen_string_literal: true

module Core
  module Migrations
    class Migrate
      include Interactor::Organizer

      organize Generate,
               GenerateBackup,
               MigrateDatabase,
               CleanSearchIndexes,
               Reload,
               RebuildSearchIndexes,
               GenerateDocumentation
    end
  end
end
