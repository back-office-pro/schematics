# frozen_string_literal: true

require 'rails'

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/sqlite3.yml.tt',
                  '124f2e295c379349970f84dfb6b7119672fdf8f5ba80a07304d3bfede21fce4c'
end
