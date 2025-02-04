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

      def call # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        migrator_old_and_changed_entities
          .reject(&:existing?)
          .map(&:class_name)
          .map(&:to_sym)
          .select(&Object.method(:const_defined?))
          .each(&Object.method(:remove_const))
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:reset_column_information)
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:define_attribute_methods)
      end
    end
  end
end
