# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Generate
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :load, to: 'Schematics::Schema.instance', private: true
      delegate :load_generators, to: 'Rails.application', private: true
      delegate :migration_clean_commands,
               :migration_build_commands,
               :data,
               to: :schema_dataset,
               private: true

      before { load_generators }

      def call
        migration_clean_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
        load(data.to_json)
        migration_build_commands
          .flat_map(&:generators)
          .each(&:invoke_all)
      rescue StandardError => exception # rubocop:disable Naming/RescuedExceptionsVariableName
        context.fail!(exception:)
      end
    end
  end
end
