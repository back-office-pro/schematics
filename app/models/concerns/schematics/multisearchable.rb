# frozen_string_literal: true

module Schematics
  module Multisearchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model
      after_restore :update_pg_search_document
      multisearchable against: multisearchable_elements

      def update_pg_search_document
        UpdatePgSearchDocumentJob.perform_later(self)
      end
    end

    class_methods do
      def rebuild_pg_search_documents = find_each(&:create_or_update_pg_search_document)

      def multisearchable_elements = entity
        .multisearchable_elements
        .map(&:name)
        .map(&:to_sym)
    end
  end
end
