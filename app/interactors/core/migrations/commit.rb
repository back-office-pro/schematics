# frozen_string_literal: true

module Core
  module Migrations
    class Commit
      include Interactor

      delegate :add, :commit, :push, to: :git, private: true
      delegate :migration, to: :context, private: true
      delegate :commit_message, to: :migration, private: true

      # :reek:UncommunicativeVariableName
      def call
        add(all: true)
        commit(commit_message, allow_empty: true)
        push('origin', 'main') if Rails.env.production?
      rescue Git::FailedError => e
        Rollbar.error(e, '[Migration] Commit error')
      end

      private

      memoize def git = ::Git.init
    end
  end
end
