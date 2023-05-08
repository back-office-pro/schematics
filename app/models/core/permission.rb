# frozen_string_literal: true

module Core
  # :reek:MissingSafeMethod
  class Permission < Schematics::ApplicationRecord
    scope :features, Permissions::FeaturesQuery

  class << self
    def create_entities_permissions! = Tenant
      .schema
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
