# frozen_string_literal: true

module MainApp
  module Permission
    extend ActiveSupport::Concern

    class_methods do
      def create_all_entities_permissions!
        Schematics::Schema
          .instance
          .entities
          .flat_map(&method(:create_entity_permissions!))
      end

      def create_entity_permissions!(entity)
        entity
          .actions_with_events
          .map { |action| create!(model: entity.class_name, action:) }
      end
    end
  end
end
