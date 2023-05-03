# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Reindex
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :migration_new_and_changed_entities, to: :schema_dataset, private: true

      def call
        return unless ::Tenant.search_engine.indexable?

        migration_new_and_changed_entities
          .filter_map(&:model_class)
          .each(&:reindex)
      end
    end
  end
end
