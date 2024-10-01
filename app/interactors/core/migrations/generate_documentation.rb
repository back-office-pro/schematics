# frozen_string_literal: true

module Core
  module Migrations
    class GenerateDocumentation
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :version, to: :migration, private: true

      progressable migration: 80

      def call
        ::Documentation.create!(app_version: version)
      end
    end
  end
end
