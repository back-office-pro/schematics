# frozen_string_literal: true

module Core
  module SchemaDatasets
    class UpdateState
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :persisted?, :state_migrated!, to: :schema_dataset, private: true

      def call
        return Rails.cache.write('CORE_VERSION', Schematics::VERSION) unless persisted?

        PaperTrail.request(enabled: false) do
          state_migrated!
        end
      end
    end
  end
end
