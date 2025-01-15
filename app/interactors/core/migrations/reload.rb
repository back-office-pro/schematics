# frozen_string_literal: true

module Core
  module Migrations
    class Reload
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_and_changed_entities,
               :migrator_new_and_changed_entities,
               :migrator_changed_entities,
               to: :migration,
               private: true

      progressable migration: 70

      def call # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        migrator_old_and_changed_entities
          .reject(&:existing?)
          .each(&method(:remove_constant))
        migrator_new_and_changed_entities
          .select(&:core?)
          .each(&method(:load_file))
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:reset_column_information)
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:define_attribute_methods)
      end

      private

      def remove_constant(entity)
        Object.__send__(:remove_const, entity.class_name.to_sym)
      end

      def load_file(entity)
        load Schematics::Engine.root.join('app', 'models', 'core', "#{entity.name}.rb")
      end
    end
  end
end
