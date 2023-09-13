# frozen_string_literal: true

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  'f41570617bc596f654a09313be18342af6b2411a7cad9ec860e6ff41973f9023'
end
