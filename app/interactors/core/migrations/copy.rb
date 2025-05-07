# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor

      delegate :copy, to: '::ActiveRecord::Migration', private: true
      delegate :root, :env, :configuration, to: '::Rails', private: true
      delegate :database_configuration, to: :configuration, private: true

      def call
        %w[primary search].each do |database|
          path = root.join(database_configuration.dig(env, database, 'migrations_paths'))
          copy path, { schematics: Schematics::Engine.root.join('db', path.basename) }
        end
      end
    end
  end
end
