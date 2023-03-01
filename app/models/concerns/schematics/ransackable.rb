# frozen_string_literal: true

module Schematics
  module Ransackable
    extend ActiveSupport::Concern

    included do
      scope :autocomplete, AutocompleteQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :multisearch, MultisearchQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :list, ListQuery.new(self) # rubocop:disable Rails/ScopeArgs
    end

    class_methods do
      def ransackable_attributes(*)
        entity
          .searchable_fields
          .grep_v(Behaviours::Preloadable)
          .map(&:name)
      end

      def ransackable_associations(*)
        entity
          .searchable_associations
          .map(&:name)
          .concat(entity.preloadable_attributes.map(&:search_column_association))
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
end
