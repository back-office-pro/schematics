# frozen_string_literal: true

module Schematics
  module Multisearchable
    extend ActiveSupport::Concern

    included do
      after_restore :create_search_index_async
      after_create_commit :create_search_index_async
      after_update_commit :rebuild_search_index_async
      after_destroy_commit :destroy_search_index_async
    end

    class_methods do
      def rebuild_search_index = find_each(&:rebuild_search_index)
    end

    def search_index_content = self
      .class
      .entity
      .multisearchable_elements
      .map { it.format(public_send(it.name)) }
      .compact_blank
      .map(&:squish)
      .join(' ')

    def create_search_index
      SearchIndex.insert_sql(
        content: search_index_content,
        searchable_type: self.class.to_s,
        searchable_id: id
      )
    end

    def destroy_search_index
      SearchIndex.delete_by(searchable_id: id)
    end

    def rebuild_search_index
      transaction do
        destroy_search_index
        create_search_index
      end
    end

    private

    def create_search_index_async
      CreateSearchIndexJob.perform_later(self)
    end

    def rebuild_search_index_async
      RebuildSearchIndexJob.perform_later(self)
    end

    def destroy_search_index_async
      DestroySearchIndexJob.perform_later(searchable_id: id)
    end
  end
end
