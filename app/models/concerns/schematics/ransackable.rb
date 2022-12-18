# frozen_string_literal: true

module Schematics
  module Ransackable
    extend ActiveSupport::Concern

    included do
      scope :autocomplete, Resources::AutocompleteQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :search, Resources::SearchQuery.new(self) # rubocop:disable Rails/ScopeArgs
    end

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
