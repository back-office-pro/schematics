# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  add_filter %w[
    app/docs/schematics
    lib/generators/app
    lib/schematics/version.rb
  ]
end
