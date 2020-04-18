require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'support/rspec_api_documentation'
require 'support/acceptance_helpers'

RSpec.configure do |config|
  config.extend AcceptanceHelpers
end
