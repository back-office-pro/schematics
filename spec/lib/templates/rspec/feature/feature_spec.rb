# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rspec/rails/active_record'

describe 'RSpec Feature spec template' do
  it_behaves_like 'an overridden file',
                  'rspec-rails',
                  '/lib/generators/rspec/feature/templates/feature_spec.rb',
                  '9c8ba4874067988a820618d37da953cdb95a4adaa3519d9929611ceb877586d0'
end
