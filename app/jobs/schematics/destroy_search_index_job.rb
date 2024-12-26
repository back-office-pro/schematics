# frozen_string_literal: true

module Schematics
  class DestroySearchIndexJob < ApplicationJob
    queue_as :search_indexes

    def perform(**)
      SearchIndex.delete_by(**)
    end
  end
end
