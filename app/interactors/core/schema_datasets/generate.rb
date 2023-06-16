# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Generate
      include Interactor

      delegate :schema_dataset, :fail!, to: :context, private: true
      delegate :migration_clean_commands,
               :migration_build_commands,
               :persisted?,
               :data,
               to: :schema_dataset,
               private: true

      before { @index = Concurrent::AtomicFixnum.new }

      # :reek:UncommunicativeVariableName
      def call
        migration_clean_commands
          .flat_map(&:generators)
          .each(&method(:invoke))
        ::Tenant.schema = data
        migration_build_commands
          .flat_map(&:generators)
          .each(&method(:invoke))
      rescue StandardError => e
        Rollbar.error(e, '[Migration] Generate error')
        fail!
      end

      def rollback
        ::Tenant.schema = ::SchemaDataset.current_data
        ::Git.init.clean(ff: true, d: true)
      end

      private

      def invoke(generator)
        generator.invoke_all
        @index.increment
        return unless persisted?

        schema_dataset.update!(progress: (@index.value / total) * 100)
      end

      def total = migration_clean_commands
        .concat(migration_build_commands)
        .flat_map(&:generators)
        .size
    end
  end
end
