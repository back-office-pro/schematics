# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :version, :state_rollbacking?, to: :migration, private: true
      delegate :really_destroy!, :save!, to: :documentation, private: true

      progressable migration: 80

      def call
        return save! unless state_rollbacking?

        really_destroy!
      end

      private

      memoize def documentation = ::Documentation.find_or_initialize_by(app_version: version)
    end
  end
end
