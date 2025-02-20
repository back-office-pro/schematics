# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor
      delegate :copy, to: '::ActiveRecord::Migration', private: true

      def call = copy(destination_path, source)

      private

      def destination_path = ::ActiveRecord::Tasks::DatabaseTasks
        .migrations_paths
        .first

      def source = { schematics: ::Schematics::Engine.root.join('db', 'migrate') }
    end
  end
end
