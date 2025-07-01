# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: false

ActiveRecord::Base.default_shard = ENV.fetch('DATABASE', 'default').to_sym

if Rails.env.on_premise?
  Rails.configuration.after_initialize do
    suppress(StandardError) do
      Configuration.instance.update_storage_services!
    end
  end
end
