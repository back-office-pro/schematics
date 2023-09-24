# frozen_string_literal: true

module Core
  module Migrations
    class Generate
      include Interactor

      delegate :migration, :fail!, to: :context, private: true
      delegate :migrator_clean_commands,
               :migrator_build_commands,
               :persisted?,
               :data,
               to: :migration,
               private: true

      before { @index = Concurrent::AtomicFixnum.new }

      # :reek:UncommunicativeVariableName
      def call
        migrator_clean_commands
          .flat_map(&:generators)
          .each(&method(:invoke))
        ::Tenant.schema = data
        migrator_build_commands
          .flat_map(&:generators)
          .each(&method(:invoke))
      rescue StandardError => e
        Rollbar.error(e, '[Migration] Generate error')
        fail!
      end

      def rollback
        ::Tenant.schema = ::Migration.current_data
        ::Git.init.clean(ff: true, d: true)
      end

      private

      def invoke(generator)
        generator.invoke_all
        @index.increment
        return unless persisted?

        PaperTrail.request(enabled: false) do
          migration.update!(progress: (@index.value / total) * 100)
        end
      end

      def total = migrator_clean_commands
        .concat(migrator_build_commands)
        .flat_map(&:generators)
        .size
    end
  end
end
