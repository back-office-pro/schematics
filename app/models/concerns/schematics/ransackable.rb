# frozen_string_literal: true

module Schematics
  module Ransackable
    extend ActiveSupport::Concern

    def ransackable_attributes(*)
      entity
        .searchable_fields
        .map(&:name)
    end

    def ransackable_associations(*)
      entity
        .searchable_associations
        .map(&:name)
    end

    def ransortable_attributes(*)
      entity
        .searchable_elements
        .map(&:name)
    end

    def ransackable_scopes(*)
      %i[with_deleted]
    end
  end
end
