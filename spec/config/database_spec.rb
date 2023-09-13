# frozen_string_literal: true

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/postgresql.yml.tt',
                  'b590d8c6cb1a7dbae92339d983e2a30d1e062e5b90425b90d50da715dbdc10dc'
end
