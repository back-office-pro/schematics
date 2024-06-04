# frozen_string_literal: true

describe 'Routes config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/routes.rb.tt',
                  '25632279cd9b6e80999d6f6e41345ca2d9f61616bdb7557b6a2e57d699719971'
end
