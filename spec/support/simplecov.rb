# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  enable_coverage_for_eval
end
