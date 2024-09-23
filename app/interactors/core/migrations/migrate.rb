# frozen_string_literal: true

module Core
  module Migrations
    class Migrate
      include Interactor::Organizer

      organize Copy,
               Generate,
               Backup,
               MigrateDatabase,
               Restore,
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
