# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Migrate
      include Interactor::Organizer

      organize Generate, MigrateDatabase, WriteDocs, Commit, Reindex
    end
  end
end
