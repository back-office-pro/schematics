# frozen_string_literal: true

module Core
  module Migrations
    class Rollback
      include Interactor::Organizer

      organize Copy,
               Generate,
               MigrateDatabase,
               RestoreBackup,
               CleanIndices,
               Reload,
               Reindex,
               CleanDocumentation,
               GenerateFixture,
               Commit,
               Restart
    end
  end
end
