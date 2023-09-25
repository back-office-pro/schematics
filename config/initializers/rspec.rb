# frozen_string_literal: true

Rails.configuration.after_initialize do
  require 'active_storage_validations/matchers'
  require 'paper_trail/frameworks/rspec'
  require 'rspec/rails'
  require 'validate_url/rspec_matcher'

  RSpec.configure do |config|
    config.include ActiveStorageValidations::Matchers
  end
end
