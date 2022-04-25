# frozen_string_literal: true

require 'simplecov'

SimpleCov.start(:rails) do
  enable_coverage :branch
  add_filter 'app/docs/schematics'
end
