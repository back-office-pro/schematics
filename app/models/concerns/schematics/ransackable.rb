# frozen_string_literal: true

module Schematics
  module Ransackable
    extend ActiveSupport::Concern

    def ransackable_attributes(_auth_object = nil)
      entity
        .searchable_fields
        .map(&:name)
    end

    def ransackable_associations(_auth_object = nil)
      entity
        .searchable_associations
        .map(&:name)
    end

    def ransortable_attributes(_auth_object = nil)
      entity
        .searchable_elements
        .map(&:name)
    end

    def ransackable_scopes(_auth_object = nil)
      %i[with_deleted]
    end
  end
end
