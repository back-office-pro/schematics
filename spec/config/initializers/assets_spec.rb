# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Assets initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/assets.rb.tt',
                  'f55d4ce66ec2b48256ff492c99c7105b7cc1726c78789dffdbee2611e193c1a6'
end
