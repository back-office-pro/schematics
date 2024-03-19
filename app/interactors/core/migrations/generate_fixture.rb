# frozen_string_literal: true

module Core
  module Migrations
    class GenerateFixture
      include Interactor
      delegate :migration, to: :context, private: true

      def call
        FileUtils.mkdir_p(fixtures_path)
        fixtures_path.join('migrations.yml').write(migration.to_yaml)
      end

      private

      def fixtures_path = ::Rails
        .root
        .join('spec/fixtures')
    end
  end
end
