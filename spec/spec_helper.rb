# frozen_string_literal: true

require 'support/simplecov' if RSpec.configuration.files_to_run.size > 200
require 'support/i18n'
require 'support/overrides'
require 'support/shared_examples'
require 'rspec/its'

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.profile_examples = 10
  config.order = :random
  Kernel.srand(config.seed)
end
