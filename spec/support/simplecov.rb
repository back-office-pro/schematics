# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  enable_coverage_for_eval
  add_filter %w[lib/schematics/version.rb]
end
