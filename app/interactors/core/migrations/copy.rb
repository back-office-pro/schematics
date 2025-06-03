# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Copy
      include Interactor

      delegate :copy, to: '::ActiveRecord::Migration', private: true
      delegate :migration, :database, to: :context, private: true
      delegate :current_shard, to: :migration, allow_nil: true, private: true

      def call
        %w[migrate search_migrate].each do |directory|
          copy(
            Rails.root.join('db', (database || current_shard).to_s, directory),
            { schematics: Schematics::Engine.root.join('db', directory) }
          )
        end
      end
    end
  end
end
