# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Generate
      include Interactor

      delegate :schema_dataset, :fail!, to: :context, private: true
      delegate :migration_clean_commands,
               :migration_build_commands,
               :data,
               to: :schema_dataset,
               private: true

      # :reek:UncommunicativeVariableName
      def call
        migration_clean_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
        ::Tenant.schema = data
        migration_build_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
      rescue StandardError => e
        Rollbar.error(e, '[Migration] Generate error')
        fail!
      end

      def rollback
        ::Tenant.schema = ::SchemaDataset.current_data
        ::Git.init.clean(ff: true, d: true)
      end
    end
  end
end
