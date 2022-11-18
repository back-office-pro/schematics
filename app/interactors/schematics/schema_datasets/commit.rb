# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Commit
      include Interactor
      delegate :clean, :add, :commit, to: :git, private: true
      delegate :schema_dataset, to: :context, private: true
      delegate :id, to: :schema_dataset, private: true

      def call
        return clean(ff: true, d: true) if Rails.env.test?

        add(all: true)
        commit("Migration #{id}", allow_empty: true)
      end

      private

      def git
        @git ||= ::Git.init
      end
    end
  end
end
