# frozen_string_literal: true

require 'rspec/rails'
require 'shoulda/matchers'
require 'active_storage_validations/matchers'
require 'validate_url/rspec_matcher'

RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
