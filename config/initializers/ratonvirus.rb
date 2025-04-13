# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Ratonvirus.configure do |config|
  config.scanner = :clamby
  config.storage = Rails.env.test? ? :filepath : :active_storage
end
