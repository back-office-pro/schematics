# frozen_string_literal: true

module Schematics
  class AssociationsQuery < ApplicationQuery
    def call(resource, ability, only = nil)
      resource
        .class
        .entity
        .has_many_and_through_and_belongs_to_many_associations
        .reject(&:existing?)
        .select(&only)
        .to_a
        .concat(resource.class.entity.attachments_attributes)
        .map do |association|
          resource
            .public_send(association.name)
            .preload(association.includes)
            .accessible_by(ability)
            .order(created_at: :desc)
        end.compact_blank
    end
  end
end
