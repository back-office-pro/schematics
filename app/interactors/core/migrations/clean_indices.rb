# frozen_string_literal: true

module Core
  module Migrations
    class CleanIndices
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_entities, to: :migration, private: true

      progressable migration: 65

      def call
        return unless ::Tenant.search_engine.indexable?

        migrator_old_entities
          .filter_map(&:model_class)
          .map(&:search_index)
          .map(&:clean_indices)
      end
    end
  end
end
