# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '5f26e0a6687bb26ade3ca742517d6f78e271bf02b90147359280372c7db119f8'
end
