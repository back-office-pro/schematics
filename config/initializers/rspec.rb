# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.to_prepare do
  next unless Rails.env.test?

  require 'active_storage_validations/matchers'
  require 'paper_trail/frameworks/rspec'
  require 'rspec/rails'
  require 'test_prof/recipes/rspec/before_all'
  require 'validate_url/rspec_matcher'

  # rails_helper
  RSpec.configure do |config|
    config.include ActiveStorageValidations::Matchers
    config.fixture_paths = [Rails.root.join('spec/fixtures')]
    config.use_transactional_fixtures = true
    config.infer_spec_type_from_file_location!
    config.filter_rails_from_backtrace!
  end

  # spec_helper
  RSpec.configure do |config|
    config.shared_context_metadata_behavior = :apply_to_host_groups
    config.expect_with :rspec do |expectations|
      expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    end
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = true
    end
  end
end
