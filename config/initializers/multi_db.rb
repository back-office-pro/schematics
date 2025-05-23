# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.application.configure do
  config.active_record.shard_selector = { lock: true }
  config.active_record.shard_resolver = -> { _1.subdomain }
end
