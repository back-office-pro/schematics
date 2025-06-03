# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor

      delegate :migration, :database, to: :context, private: true
      delegate :current_shard, to: :migration, allow_nil: true, private: true

      def call = Schematics::Engine
        .root
        .glob('db/*migrate')
        .each(&method(:copy_migrations))

      private

      def copy_migrations(directory)
        ActiveRecord::Migration.copy(
          Rails.root.join('db', (database || current_shard).to_s, directory.basename),
          { schematics: directory }
        )
      end
    end
  end
end
