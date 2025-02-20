# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'capybara/rspec'
require 'view_component/test_helpers'

RSpec.configure do |config|
  config.include Schematics::ResourcesHelper, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::DSL, type: :component
end
