# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class RebuildSearchIndexes
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_and_changed_entities, :current_shard, to: :migration, private: true
      delegate :perform_all_later, to: '::ActiveJob', private: true

      progressable migration: 80

      def call = perform_all_later(
        migrator_new_and_changed_entities
          .filter_map(&:class_name)
          .map { Schematics::RebuildSearchIndexJob.new(current_shard, _1) }
      )
    end
  end
end
