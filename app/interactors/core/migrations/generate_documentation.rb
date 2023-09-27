# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Interactor

      delegate :migration, to: :context, private: true
      delegate :data_version, :state_rollbacking?, to: :migration, private: true

      def call
        PaperTrail.request(enabled: false) do
          state_rollbacking? ? documentation.really_destroy! : documentation.save!
        end
      end

      private

      memoize def documentation = ::Documentation.find_or_initialize_by(app_version: data_version)
    end
  end
end
