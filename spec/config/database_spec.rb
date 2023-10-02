# frozen_string_literal: true

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/postgresql.yml.tt',
                  '5bf8434b9077c5ea433a780153d20f9ae88b256b730e80e59d9b01f3518954be'
end
