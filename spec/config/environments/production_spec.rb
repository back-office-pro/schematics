# frozen_string_literal: true

require 'rails'

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '0eb88f59ca14c6ce07d7230ab5c483eb6b2fa46ce39e5c8c9efbb655d2f69823'
end
