# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_schema, :version, to: :migration, private: true

      progressable migration: 100

      def call = ::Documentation.create!(
        schema: migrator_new_schema,
        app_version: version
      )
    end
  end
end
