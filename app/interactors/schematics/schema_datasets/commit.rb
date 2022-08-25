# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Commit
      include Interactor
      delegate :clean, :add, :commit, to: :git, private: true

      before do
        @schema_dataset = context.schema_dataset
      end

      def call
        return clean(ff: true, d: true) if Rails.env.test?

        add(all: true)
        commit("Migration #{@schema_dataset.id}")
      end

      private

      def git
        @git ||= ::Git.init
      end
    end
  end
end
