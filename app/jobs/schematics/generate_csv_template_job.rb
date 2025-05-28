# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateCSVTemplateJob < ApplicationJob
    include Shardable
    limits_concurrency key: ->(shard, user_id, *) { [shard, user_id] }
    queue_as :default

    def perform(_shard, user_id, model_name)
      user = ::User.find(user_id)
      model_class = model_name.constantize
      serializer = CSVTemplateSerializer.new(model_class)
      Resources::GenerateFile.call(user:, serializer:, component_method: :csv_template)
    end
  end
end
