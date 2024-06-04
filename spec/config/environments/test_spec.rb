# frozen_string_literal: true

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  '9ded9cdbbc15dfdf5e1e4b387b630d51d04d0a3374f569667d3e75ae8a898cc2'
end
