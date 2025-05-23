# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor

      delegate :copy, to: '::ActiveRecord::Migration', private: true
      delegate :root, :env, :configuration, to: '::Rails', private: true
      delegate :database_configuration, to: :configuration, private: true
      delegate :basename, to: :migrations_path, private: true

      def call = copy(migrations_path, schematics: Schematics::Engine.root.join('db', basename))

      private

      def migrations_path = root.join(database_configuration.dig(env, 'migrations_paths'))
    end
  end
end
