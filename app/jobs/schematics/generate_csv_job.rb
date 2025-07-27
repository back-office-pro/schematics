# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateCSVJob < ApplicationJob
    include Shardable

    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(_shard, user_id, model_name, resource_ids, dropdown)
      user = ::User.find(user_id)
      resources = model_name.constantize.find(resource_ids)
      serializer = CSVSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
