# frozen_string_literal: true

module Core
  module Migrations
    class GenerateFixture
      include Interactor
      delegate :migration, to: :context, private: true

      def call = ::Rails
        .root
        .join('spec/fixtures/migrations.yml')
        .write(migration.to_yaml)
    end
  end
end
