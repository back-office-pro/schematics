# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Commit
      include Interactor
      delegate :add, :commit, :push, to: :git, private: true
      delegate :schema_dataset, to: :context, private: true
      delegate :id, to: :schema_dataset, private: true

      def call
        return if Rails.env.test?

        add(all: true)
        commit("Migration #{id}", allow_empty: true)
        push('origin') if Rails.env.production?
      end

      private

      def git
        @git ||= ::Git.init
      end
    end
  end
end
