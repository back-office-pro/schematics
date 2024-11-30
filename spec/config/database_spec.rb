# frozen_string_literal: true

require 'rails'

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/postgresql.yml.tt',
                  'dc3af2c354c1b5f95f276f2a7f0d81c4550794272a3838b10d3ebda659a71547'
end
