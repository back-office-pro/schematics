# frozen_string_literal: true

module Schematics
  module Searchable
    extend ActiveSupport::Concern

    included do
      scope :autocomplete, ->(*args) { Searches::AutocompleteQuery.new(self).(*args) } # rubocop:disable Style/LambdaCall
      scope :list, ->(*args) { Searches::ListQuery.new(self).(*args) } # rubocop:disable Style/LambdaCall
    end

    class_methods do
      def ransackable_attributes(*)
        entity
          .searchable_fields
          .map(&:name)
      end

      def ransackable_associations(*)
        entity
          .searchable_associations
          .map(&:name)
          .concat(entity.rich_text_attributes.map(&:search_column_association))
          .concat(entity.attachment_attributes.map(&:search_column_association))
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
