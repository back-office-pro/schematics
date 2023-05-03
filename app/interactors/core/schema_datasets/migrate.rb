# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Migrate
      include Interactor::Organizer

      organize Generate,
               Backup,
               MigrateDatabase,
               CleanIndices,
               Reload,
               Reindex,
               Commit,
               UpdateState
    end
  end
end
