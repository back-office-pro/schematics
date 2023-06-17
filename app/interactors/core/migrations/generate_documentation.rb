# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Interactor
      delegate :migration, to: :context, private: true

      def call
        PaperTrail.request(enabled: false) do
          ::Documentation.create!(app_version:)
        end
      end

      private

      def app_version
        migration.data_version || ::Migration.current_data_version
      end
    end
  end
end
