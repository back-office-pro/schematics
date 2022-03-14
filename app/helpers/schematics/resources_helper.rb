# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    def resource_associations(resource:, only_required: false)
      attachments_attributes(resource)
        .concat(associations(resource, only_required))
        .compact_blank
    end

    private

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

    def associations(resource, only_required)
      entity
        .has_many_and_through_and_belongs_to_many_associations
        .reject { !_1.required? if only_required }
        .map do |association|
        resource
          .public_send(association.name)
          .includes(association.entity.includes)
          .accessible_by(current_ability)
          .order(created_at: :desc)
      end
    end
  end
end
