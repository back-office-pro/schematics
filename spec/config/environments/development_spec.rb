# frozen_string_literal: true

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  'f8b98f6bef8fd027ad9fb8a44a1c09a7b74bd461c9cde3ad90579c9e26376b1c'
end
