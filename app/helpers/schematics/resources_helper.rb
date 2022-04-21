# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    def resource_associations(resource:, only: nil)
      attachments_attributes(resource)
        .concat(associations(resource, only))
        .compact_blank
    end

    private

    HABTM = Associations::HasAndBelongsToMany

    def attachments_attributes(resource)
      entity
        .attachments_attributes
        .map do |attribute|
        resource
          .public_send(attribute.name)
          .includes(:blob)
          .order(created_at: :desc)
      end
    end

    def associations(resource, filter_key)
      entity
        .has_many_and_through_and_belongs_to_many_associations
        .select(&filter_key)
        .map do |association|
        resource
          .public_send(association.name)
          .then_tap { _1.includes(association.entity.includes) unless association.is_a?(HABTM) }
          .accessible_by(current_ability)
          .order(created_at: :desc)
      end
    end
  end
end
