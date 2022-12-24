# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class CleanIndices
      include Interactor
      delegate :schema_dataset, to: :context, private: true
      delegate :migration_old_entities, to: :schema_dataset, private: true

      def call
        return unless ::Tenant.search_engine.indexable?

        migration_old_entities
          .filter_map(&:model_class)
          .map(&:search_index)
          .map(&:clean_indices)
      end
    end
  end
end
