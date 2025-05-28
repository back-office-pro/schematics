# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RebuildSearchIndexJob < ApplicationJob
    include Shardable
    queue_as :low

    def perform(_shard, model_name, resource_id = nil)
      model_name
        .constantize
        .then_tap { _1.find(resource_id) if resource_id }
        .rebuild_search_index
    end
  end
end
