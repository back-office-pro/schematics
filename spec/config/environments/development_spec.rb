# frozen_string_literal: true

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  'cbcaac8e5d2e93a0809eff395aae6be1782da504ceb9ca5c71dcc578aa626ac5'
end
