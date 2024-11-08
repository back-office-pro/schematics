# frozen_string_literal: true

module Core
  module Migrations
    class CleanIndices
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_entities, to: :migration, private: true

      progressable migration: 65

      def call = migrator_old_entities
        .filter_map(&:class_name)
        .map { |searchable_type| PgSearch::Document.delete_by(searchable_type:) }
    end
  end
end
