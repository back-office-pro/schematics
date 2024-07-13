# frozen_string_literal: true

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  'd47715a9d19d86ea2859750b0c0684ef47866ab74dd3ecbc5f36a5647789dca2'
end
