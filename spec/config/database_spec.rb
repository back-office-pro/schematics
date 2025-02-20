# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/sqlite3.yml.tt',
                  '8ffacee0d7d78c644047d82aad56606138069f3bebc113e9daf810850dee7980'
end
