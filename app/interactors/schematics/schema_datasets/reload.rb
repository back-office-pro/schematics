# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reload
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :reload!, to: '::OpenApi::Router', private: true
      delegate :migration_old_classes,
               :migration_new_classes,
               to: :schema_dataset,
               private: true

      def call
        return if Rails.env.test?

        reload!
        migration_old_classes.each do |class_name|
          Object.__send__(:remove_const, class_name.to_sym)
          Object.__send__(:remove_const, :"#{class_name.pluralize}Controller".to_sym)
        end
        migration_new_classes.each do |name|
          load ::Rails.root.join('app', 'models', "#{name}.rb")
          load ::Rails.root.join('app', 'controllers', "#{name.pluralize}_controller.rb")
        end
      end
    end
  end
end
