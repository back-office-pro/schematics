# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
`bin/rails db:test:prepare`
require File.expand_path('../config/environment', __dir__)

require 'active_storage_validations/matchers'
require 'paper_trail/frameworks/rspec'
require 'rspec/rails'
require 'test_prof/recipes/rspec/before_all'
require 'validate_url/rspec_matcher'

require 'support/cache'
require 'support/capybara'
require 'support/isolator'
require 'support/shared_contexts'
require 'support/shoulda_matchers'
require 'support/view_component'
require 'support/webmock'

RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include_context 'with password pwned stub'
end
