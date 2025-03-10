# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class Reload
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_and_changed_entities,
               :migrator_changed_entities,
               to: :migration,
               private: true

      progressable migration: 75

      def call
        Rails.cache.delete('schema:current')
        Rails.cache.write('old_and_changed_model_classes', old_and_changed_model_classes)
        old_and_changed_model_classes
          .select(&Object.method(:const_defined?))
          .each(&Object.method(:remove_const))
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:reset_column_information)
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:define_attribute_methods)
      end

      private

      def old_and_changed_model_classes = migrator_old_and_changed_entities
        .reject(&:existing?)
        .map(&:class_name)
        .map(&:to_sym)
    end
  end
end
