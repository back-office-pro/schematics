# frozen_string_literal: true

module Schematics
  class DestroySearchIndexJob < ApplicationJob
    queue_as :search_indexes

    def perform(resource)
      resource.destroy_search_index
    end
  end
end
