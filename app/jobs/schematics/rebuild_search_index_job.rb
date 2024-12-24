# frozen_string_literal: true

module Schematics
  class RebuildSearchIndexJob < ApplicationJob
    queue_as :search_indexes

    def perform(resource)
      resource.rebuild_search_index
    end
  end
end
