# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor
      delegate :copy, to: '::ActiveRecord::Migration', private: true
      delegate :database_name, to: '::Tenant', private: true

      def call
        %w[migrate search_migrate].each do |directory|
          copy(
            Rails.root.join('db', database_name, directory),
            { schematics: Schematics::Engine.root.join('db', directory) }
          )
        end
      end
    end
  end
end
