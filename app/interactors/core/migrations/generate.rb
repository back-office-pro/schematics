# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    # :reek:MissingSafeMethod
    class Generate
      include Schematics::Progressable

      delegate :migration, :fail!, to: :context, private: true
      delegate :migrator_clean_commands,
               :migrator_build_commands,
               :persisted?,
               to: :migration,
               private: true

      progressable migration: 40

      before { @index = Concurrent::AtomicFixnum.new }

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

      def rollback = ::Git
        .init
        .clean(ff: true, d: true)

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
