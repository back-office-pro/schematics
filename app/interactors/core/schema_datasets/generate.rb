# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Generate
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :migration_clean_commands,
               :migration_build_commands,
               :data,
               to: :schema_dataset,
               private: true

      def call
        migration_clean_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
        ::Tenant.schema = data
        migration_build_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
      end
    end
  end
end
