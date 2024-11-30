# frozen_string_literal: true

module Schematics
  class UpdatePgSearchDocumentJob < ApplicationJob
    queue_as :reindex

    self.enqueue_after_transaction_commit = true

    def perform(resource)
      resource.create_or_update_pg_search_document
    end
  end
end
