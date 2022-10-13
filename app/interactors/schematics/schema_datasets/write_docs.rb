# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class WriteDocs
      include Interactor
      delegate :schema_dataset, to: :context, private: true
      delegate :app_env, to: 'Schematics::Engine', private: true

      def call
        schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
        system "RAILS_ENV=#{app_env} rails schematics:docs:generate"
      end
    end
  end
end
