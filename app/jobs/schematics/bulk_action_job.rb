# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class BulkActionJob < ApplicationJob
    include Shardable
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(_shard, whodunnit, model_name, ids)
      PaperTrail.request(whodunnit:) do
        model_name
          .constantize
          .preload_all
          .where(id: ids)
          .find_each { |resource| Resources::Archive.call(resource:) }
      end
    end
  end
end
