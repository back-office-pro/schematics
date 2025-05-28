# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class CleanSearchIndexes
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_entities, :current_shard, to: :migration, private: true
      delegate :perform_all_later, to: '::ActiveJob', private: true

      progressable migration: 65

      def call = perform_all_later(
        migrator_old_entities
          .filter_map(&:class_name)
          .map do |searchable_type|
            Schematics::DestroySearchIndexJob.new(current_shard, searchable_type:)
          end
      )
    end
  end
end
