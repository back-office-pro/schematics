# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Commit
      include Interactor

      delegate :add, :commit, :push, to: :git, private: true
      delegate :schema_dataset, to: :context, private: true

      # :reek:UncommunicativeVariableName
      def call
        add(all: true)
        commit("Migration #{migration_version}", allow_empty: true)
        push('origin', 'main') if Rails.env.production?
      rescue Git::FailedError => e
        Rollbar.error(e, '[Migration] Commit error')
      end

      private

      def git
        @git ||= ::Git.init
      end

      def migration_version
        schema_dataset.data_version || "core #{Schematics::VERSION}"
      end
    end
  end
end
