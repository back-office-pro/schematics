# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    def resource_associations(resource:, only_required: false)
      @resource_associations ||= attachments_attributes(resource)
                                 .concat(associations(resource, only_required))
                                 .compact_blank
    end

    private

    def attachments_attributes(resource)
      @attachments_attributes ||= entity
                                  .attachments_attributes
                                  .map do |attribute|
        resource
          .public_send(attribute.name)
          .includes(:blob)
      end
    end

    def associations(resource, only_required)
      @associations ||= entity
                        .has_many_and_through_and_belongs_to_many_associations
                        .take_while { |association| !(only_required && !association.required?) }
                        .map do |association|
        resource
          .public_send(association.name)
          .includes(association.entity.includes)
          .accessible_by(current_ability)
      end
    end
  end
end
