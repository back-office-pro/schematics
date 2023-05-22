# frozen_string_literal: true

module Core
  module SchemaDatasets
    class Commit
      include Interactor

      delegate :add, :commit, :push, to: :git, private: true
      delegate :schema_dataset, to: :context, private: true
      delegate :id, to: :schema_dataset, private: true

      def call
        add(all: true)
        commit("Migration #{id}", allow_empty: true)
        push('origin', 'main') if Rails.env.production?
      rescue Git::FailedError => e
        Rollbar.error(e, 'Git push error')
      end

      private

      def git
        @git ||= ::Git.init
      end
    end
  end
end
