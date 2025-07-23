# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GeneratePDFJob < ApplicationJob
    include Shardable
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(_shard, user_id, model_name, resource_id)
      user = ::User.find(user_id)
      resource = model_name.constantize.find(resource_id)
      serializer = PDFSerializer.new(resource)
      Resources::GenerateFile.call(user:, serializer:)
    end
  end
end
