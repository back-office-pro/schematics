# frozen_string_literal: true

module Schematics
  class RebuildPgSearchDocumentsJob < ApplicationJob
    queue_as :reindex

    def perform(model_class)
      ::PgSearch::Multisearch.rebuild(model_class)
    end
  end
end
