# frozen_string_literal: true

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  'ea7bf8f5329b065a6b57e87f32aeb7d6af605a3d5d8990c84487d647354369dd'
end
