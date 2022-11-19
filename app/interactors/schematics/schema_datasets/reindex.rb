# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reindex
      include Interactor
      delegate :schema_dataset, to: :context, private: true
      delegate :migration_entities, to: :schema_dataset, private: true

      def call = migration_entities
        .filter_map(&:model_class)
        .each(&:reindex)
    end
  end
end
