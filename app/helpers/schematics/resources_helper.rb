# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    def resource_associations(only_required: false)
      @resource_associations ||= attachments_attributes
                                 .concat(associations(only_required))
                                 .reject(&:empty?)
    end

    private

    def attachments_attributes
      @attachments_attributes ||= entity
                                  .attachments_attributes
                                  .map do |attribute|
        resource
          .instance_eval(attribute.name)
          .includes(:blob)
      end
    end

    def associations(only_required)
      @associations ||= entity
                        .has_many_and_through_and_belongs_to_many_associations
                        .take_while { |association| !(only_required && !association.required?) }
                        .map do |association|
        resource
          .instance_eval(association.name)
          .includes(association.entity.includes)
          .accessible_by(current_ability)
      end
    end
  end
end
