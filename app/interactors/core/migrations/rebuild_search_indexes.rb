# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class RebuildSearchIndexes
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_and_changed_entities, to: :migration, private: true
      delegate :perform_all_later, to: '::ActiveJob', private: true

      progressable migration: 85

      def call = perform_all_later(
        migrator_new_and_changed_entities
          .filter_map(&:model_class)
          .map(&Schematics::RebuildSearchIndexJob.method(:new))
      )
    end
  end
end
