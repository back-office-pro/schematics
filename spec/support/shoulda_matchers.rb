# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'shoulda/callback/matchers'
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
