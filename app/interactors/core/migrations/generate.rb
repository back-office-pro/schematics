# frozen_string_literal: true

module Core
  module Migrations
    # :reek:MissingSafeMethod
    class Generate
      include Interactor

      delegate :migration, :fail!, to: :context, private: true
      delegate :migrator_clean_commands,
               :migrator_build_commands,
               :persisted?,
               :data,
               to: :migration,
               private: true

      before :set_index
      after :update_progress!

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

      def set_index
        @index = Concurrent::AtomicFixnum.new
      end

      def update_progress!(progress = 100)
        migration.update!(progress:)
      end

      def invoke(generator)
        generator.invoke_all
        @index.increment
        return unless persisted?

        update_progress!(@index.value.to_f / total * 100)
      end

      def total = migrator_clean_commands
        .concat(migrator_build_commands)
        .flat_map(&:generators)
        .size
    end
  end
end
