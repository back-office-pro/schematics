# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  enable_coverage_for_eval
  add_filter %w[
    app/docs/schematics
    lib/generators/app
    lib/schematics/version.rb
    lib/rubygems_plugin.rb
  ]
end
