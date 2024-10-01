# frozen_string_literal: true

module Core
  module Migrations
    # :reek:MissingSafeMethod
    class Generate
      include Schematics::Progressable

      delegate :migration, :fail!, to: :context, private: true
      delegate :migrator_clean_commands,
               :migrator_build_commands,
               :migrator_new_schema,
               :persisted?,
               to: :migration,
               private: true

      progressable migration: 40

      before { @index = Concurrent::AtomicFixnum.new }

      # :reek:UncommunicativeVariableName
      def call
        migrator_clean_commands
          .flat_map(&:generators)
          .each(&method(:invoke))
        ::Tenant.schema = migrator_new_schema
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

        update_progress!(@index.value.to_f / total * self.class.progress)
      end

      def total = migrator_clean_commands
        .concat(migrator_build_commands)
        .flat_map(&:generators)
        .size
    end
  end
end
