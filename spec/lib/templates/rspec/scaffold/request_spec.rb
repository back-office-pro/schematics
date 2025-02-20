# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rspec/rails/active_record'

describe 'RSpec Request spec template' do
  it_behaves_like 'an overridden file',
                  'rspec-rails',
                  '/lib/generators/rspec/scaffold/templates/request_spec.rb',
                  'ac04b9c1a5a328efa4389ddf9b56a05c0d9615f13c34ff03f8d6f46250b1c44d'
end
