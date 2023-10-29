# frozen_string_literal: true

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/postgresql.yml.tt',
                  'cf836badc3400deddbf8343430501d73dd0691338d736d3a38048d626b9813f6'
end
