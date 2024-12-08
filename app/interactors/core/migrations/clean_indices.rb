# frozen_string_literal: true

module Core
  module Migrations
    class CleanIndices
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_entities, to: :migration, private: true

      progressable migration: 65

      def call = PgSearch::Document.delete_by(
        searchable_type: migrator_old_entities.filter_map(&:class_name)
      )
    end
  end
end
