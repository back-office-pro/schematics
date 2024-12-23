# frozen_string_literal: true

module Schematics
  class RebuildSearchIndexJob < ApplicationJob
    queue_as :search_indexes

    def perform(resource)
      case resource
      when Class
        resource.find_each(&:rebuild_search_index)
      else
        resource.rebuild_search_index
      end
    end
  end
end
