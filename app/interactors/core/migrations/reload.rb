# frozen_string_literal: true

module Core
  module Migrations
    class Reload
      include Interactor

      delegate :migration, to: :context, private: true
      delegate :reload!, to: ::OpenApi::Router, private: true
      delegate :migrator_old_and_changed_entities,
               :migrator_new_and_changed_entities,
               :migrator_changed_entities,
               to: :migration,
               private: true

      before :reload!

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
        Object.__send__(:remove_const, entity.class_name.to_sym)
        Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
      end

      def load_files(entity)
        case entity
        when proc(&:existing?)
          load Schematics::Engine.root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb") # rubocop:disable Layout/LineLength
        when proc(&:core?)
          load Schematics::Engine.root.join('app', 'models', 'core', "#{entity.name}.rb")
          load Schematics::Engine.root.join('app', 'controllers', 'core', "#{entity.name.pluralize}_controller.rb") # rubocop:disable Layout/LineLength
        else
          load ::Rails.root.join('app', 'models', "#{entity.name}.rb")
          load ::Rails.root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
        end
      end
    end
  end
end
