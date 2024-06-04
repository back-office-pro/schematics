# frozen_string_literal: true

describe 'Database config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/databases/postgresql.yml.tt',
                  '79353d10f4525c42119cb51c0507d939ce6477870145bd23c929533666abcb17'
end
