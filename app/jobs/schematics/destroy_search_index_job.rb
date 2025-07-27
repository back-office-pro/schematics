# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DestroySearchIndexJob < ApplicationJob
    include Shardable

    queue_as :low

    def perform(_shard, **)
      SearchIndex.delete_by(**)
    end
  end
end
