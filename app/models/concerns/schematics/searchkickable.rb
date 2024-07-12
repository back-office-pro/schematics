# frozen_string_literal: true

module Schematics
  module Searchkickable
    extend ActiveSupport::Concern

    included do
      extend ::Pagy::Searchkick

      scope :autocomplete, AutocompleteQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :multisearch, MultisearchQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :list, ListQuery.new(self) # rubocop:disable Rails/ScopeArgs

      searchkick searchable: searchkick_elements,
                 filterable: searchkick_elements,
                 word_middle: searchkick_elements,
                 suggest: searchkick_elements,
                 callbacks: :async,
                 index_name:
    end

    class_methods do
      def index_name = -> { ::Tenant.index_name(model_name) }

      def reindex_async = reindex(mode: :async)

      def searchkick_elements = entity
        .searchable_elements
        .map(&:name)
        .map(&:to_sym)
    end
  end
end
