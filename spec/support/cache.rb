# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

RSpec.configure do |config|
  config.after { Rails.cache.clear }
end
