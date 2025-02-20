# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rspec/rails/active_record'

describe 'RSpec Routing spec template' do
  it_behaves_like 'an overridden file',
                  'rspec-rails',
                  '/lib/generators/rspec/scaffold/templates/routing_spec.rb',
                  '00944e02136165382b1711a9251a6a06c09b17d7777f407ad8091d170e53488b'
end
