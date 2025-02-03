# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_schema, :version, to: :migration, private: true

      progressable migration: 80

      def call
        ::Documentation.create_with_default_data!(app_version: version, data:)
      end

      private

      def data = ::OpenAPI::Root
        .new(schema: migrator_new_schema)
        .to_h
    end
  end
end
