# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class NotifyJob < ApplicationJob
    include Shardable

    queue_as :low

    def perform(_shard, model_name, resource_id, event, user_id)
      user = ::User.find(user_id)
      item = model_name.constantize.find(resource_id)
      Version.find_or_create_by!(item:, event:, user:)
    end
  end
end
