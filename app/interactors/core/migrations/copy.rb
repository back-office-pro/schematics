# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor
      delegate :copy, to: '::ActiveRecord::Migration', private: true
      delegate :database_name, to: '::Tenant', private: true

      def call = copy(destination_path, source)

      private

      def destination_path = Schematics::Engine
        .root
        .join('db', "#{database_name}_migrate")

      def source = { schematics: ::Schematics::Engine.root.join('db', 'migrate') }
    end
  end
end
