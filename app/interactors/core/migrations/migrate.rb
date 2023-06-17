# frozen_string_literal: true

module Core
  module Migrations
    class Migrate
      include Interactor::Organizer

      organize Generate,
               Backup,
               MigrateDatabase,
               CleanIndices,
               Reload,
               Reindex,
               GenerateDocumentation,
               Commit
    end
  end
end
