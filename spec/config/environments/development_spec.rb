# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  '91a1a0e1407ac9732751a0d38ffe72b75320fb87f006a1694772e6a379067834'
end
