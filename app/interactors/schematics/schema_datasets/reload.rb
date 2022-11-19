# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reload
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :reload!, to: '::OpenApi::Router', private: true
      delegate :migration_old_entities,
               :migration_new_entities,
               to: :schema_dataset,
               private: true

      def call
        return if Rails.env.test?

        reload!
        migration_old_entities.each do |entity|
          Object.__send__(:remove_const, entity.class_name.to_sym)
          Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
        end
        migration_new_entities.each do |entity|
          load ::Rails.root.join('app', 'models', "#{entity.name}.rb")
          load ::Rails.root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
        end
      end
    end
  end
end
