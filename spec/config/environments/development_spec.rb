# frozen_string_literal: true

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  '92235d8845a27f542baf4fd5d133b1b4e320b08007c990b5180d81b69a068242'
end
