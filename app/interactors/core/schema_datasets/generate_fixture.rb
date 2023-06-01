# frozen_string_literal: true

module Core
  module SchemaDatasets
    class GenerateFixture
      include Interactor
      delegate :schema_dataset, to: :context, private: true

      def call = ::Rails
        .root
        .join('spec/fixtures/schema_datasets.yml')
        .write(schema_dataset.to_yaml)
    end
  end
end
