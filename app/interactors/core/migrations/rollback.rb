# frozen_string_literal: true

module Core
  module Migrations
    class Rollback
      include Interactor::Organizer

      organize Generate,
               MigrateDatabase,
               RestoreBackup,
               CleanSearchIndexes,
               Reload,
               RebuildSearchIndexes,
               CleanDocumentation
    end
  end
end
