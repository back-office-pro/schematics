# frozen_string_literal: true

module Application
  module Permission
    extend ActiveSupport::Concern

    prepended do
      scope :features, FeaturesQuery
    end

    class_methods do
      def create_all_entities_permissions! = ::Tenant
        .current_schema
        .entities
        .reject(&:hidden?)
        .flat_map(&method(:create_entity_permissions!))

      def create_entity_permissions!(entity)
        entity
          .actions_with_events
          .map { |action| create!(model: entity.class_name, action:) }
      end
    end
  end
end
