# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Migrate
      include Interactor::Organizer

      organize Generate,
               CleanIndices,
               Reload,
               Backup,
               MigrateDatabase,
               WriteDocs,
               Reindex,
               Commit,
               UpdateState
    end
  end
end
