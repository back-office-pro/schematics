# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rspec/rails/active_record'

describe 'RSpec Model spec template' do
  it_behaves_like 'an overridden file',
                  'rspec-rails',
                  '/lib/generators/rspec/model/templates/model_spec.rb',
                  'a117d3c750e33056d493cb0a9424a405f2e0c6c86e501bcbc366a5de889c8f6a'
end
