# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CreateSearchIndexJob < ApplicationJob
    include Shardable
    queue_as :low

    def perform(_shard, model_name, resource_id)
      model_name.constantize.find(resource_id).create_search_index
    end
  end
end
