# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reload
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :reload!, to: '::OpenApi::Router', private: true
      delegate :migration_old_and_changed_entities,
               :migration_new_and_changed_entities,
               :migration_changed_entities,
               to: :schema_dataset,
               private: true

      def call
        reload!
        migration_old_and_changed_entities.each(&method(:remove_constants))
        migration_new_and_changed_entities.each(&method(:load_files))
        migration_changed_entities
          .map(&:model_class)
          .each(&:reset_column_information)
        migration_changed_entities
          .map(&:model_class)
          .each(&:define_attribute_methods)
      end

      private

      def remove_constants(entity)
        Object.__send__(:remove_const, entity.class_name.to_sym)
        Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
      end

      def load_files(entity)
        load ::Rails.root.join('app', 'models', "#{entity.name}.rb")
        load ::Rails.root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
      end
    end
  end
end
