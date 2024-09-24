# frozen_string_literal: true

module Core
  module Migrations
    class Migrate
      include Interactor::Organizer

      organize Copy,
               Generate,
               GenerateBackup,
               MigrateDatabase,
               RestoreBackup,
               CleanIndices,
               Reload,
               Reindex,
               GenerateDocumentation,
               GenerateFixture,
               Commit,
               Restart
    end
  end
end
