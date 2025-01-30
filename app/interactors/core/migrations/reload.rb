# frozen_string_literal: true

module Core
  module Migrations
    class Reload
      include Interactor

      delegate :reload_routes!, to: 'Rails.application', private: true
      delegate :migration, to: :context, private: true
      delegate :migrator_old_and_changed_entities,
               :migrator_changed_entities,
               to: :migration,
               private: true

      before :reload_routes!

      def call
        migrator_old_and_changed_entities
          .reject(&:existing?)
          .each(&method(:remove_constant))
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
    end
  end
end
