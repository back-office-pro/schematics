# frozen_string_literal: true

module Core
  module Migrations
    class Reindex
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_and_changed_entities, to: :migration, private: true

      progressable migration: 75

      def call = migrator_new_and_changed_entities
        .filter_map(&:model_class)
        .each(&PgSearch::Multisearch.method(:rebuild))
    end
  end
end
