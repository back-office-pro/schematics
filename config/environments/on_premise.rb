# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require_relative 'production'

Rails.application.configure do
  # Active Storage
  config.active_storage.service = :local
end
