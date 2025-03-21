# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/sqlite3.yml.tt',
                  'bddf0a77caa0edb745382fe8b35fb0d16dd37a94c5c0468266bc0ffb03da5874'
end
