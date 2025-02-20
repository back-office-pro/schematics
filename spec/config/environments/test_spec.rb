# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  '5fbb4ca3f352334311d73ebc6a2b586c04cb14db5dc4239baff3ad2ffe303004'
end
