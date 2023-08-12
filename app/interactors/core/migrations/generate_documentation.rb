# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Interactor

      delegate :migration, to: :context, private: true
      delegate :data_version, to: :migration, private: true

      def call
        PaperTrail.request(enabled: false) do
          ::Documentation.create!(app_version: data_version)
        end
      end
    end
  end
end
