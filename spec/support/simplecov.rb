# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  enable_coverage_for_eval
  add_filter %w[
    lib/generators/app
    lib/schematics/version.rb
    lib/rubygems_plugin.rb
  ]
end
