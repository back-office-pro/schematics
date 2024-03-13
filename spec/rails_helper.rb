# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
`cd spec/demo && rails db:test:prepare`
require File.expand_path('../spec/demo/config/environment', __dir__)
require 'isolator'
require 'paper_trail/frameworks/rspec'
require 'support/capybara'
require 'support/shared_contexts'
require 'support/view_component'
require 'support/webmock'

RSpec.configure do |config|
  config.include_context 'with password pwned stub'
end
