# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'spec_helper'
`cd spec/demo && rails db:schema:dump DATABASE=demo`
ENV['RAILS_ENV'] ||= 'test'
`cd spec/demo && rails db:test:prepare`
require File.expand_path('../spec/demo/config/environment', __dir__)
require 'paper_trail/frameworks/rspec'
require 'support/cache'
require 'support/capybara'
require 'support/isolator'
require 'support/shared_contexts'
require 'support/view_component'
require 'support/webmock'

RSpec.configure do |config|
  config.include_context 'with password pwned stub'
end
