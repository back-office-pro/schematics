# frozen_string_literal: true

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '8e6f5240a537e4e01ce884b181f61f2b834a823298fa72520879e2929dc8009d'
end
