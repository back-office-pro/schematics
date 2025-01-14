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

      def call
        migrator_old_and_changed_entities.each(&method(:remove_constants))
        migrator_new_and_changed_entities.each(&method(:load_files))
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:reset_column_information)
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:define_attribute_methods)
      end

      private

      def remove_constants(entity)
        Object.__send__(:remove_const, entity.class_name.to_sym) unless entity.existing?
      end

      def load_files(entity)
        case entity
        when proc(&:existing?)
          # do nothing
        when proc(&:core?)
          load Schematics::Engine.root.join('app', 'models', 'core', "#{entity.name}.rb")
        else
          load ::Rails.root.join('app', 'models', "#{entity.name}.rb")
        end
      end
    end
  end
end
