# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    # :reek:MissingSafeMethod
    class Generate
      include Schematics::Progressable

      delegate :migration, :fail!, to: :context, private: true
      delegate :root, :env, :configuration, to: '::Rails', private: true
      delegate :database_configuration, to: :configuration, private: true
      delegate :migrator_clean_commands,
               :migrator_build_commands,
               :persisted?,
               to: :migration,
               private: true

      progressable migration: 40

      before do
        @index = Concurrent::AtomicFixnum.new
        @files = migration_files
      end

      # :reek:UncommunicativeVariableName
      def call
        migrator_clean_commands
          .concat(migrator_build_commands)
          .flat_map(&:generators)
          .each(&method(:invoke))
      rescue StandardError => e
        Rollbar.error(e, '[Migration] Generate error')
        fail!
      end

      def rollback = migration_files
        .excluding(@files)
        .each(&:delete)

      private

      def invoke(generator)
        generator.invoke_all
        @index.increment
        return unless persisted?

        update_progress!(@index.value.to_f / total * self.class.progress)
      end

      def migration_files = root.glob(
        database_configuration.dig(env, 'migrations_paths').concat('/*')
      )

      def total = migrator_clean_commands
        .concat(migrator_build_commands)
        .flat_map(&:generators)
        .size
    end
  end
end
