# frozen_string_literal: true

require 'rspec/rails'
require 'active_storage_validations/matchers'
require 'validate_url/rspec_matcher'
require 'paper_trail/frameworks/rspec'

RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers
end
