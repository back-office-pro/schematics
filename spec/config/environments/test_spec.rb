# frozen_string_literal: true

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  'a6e2ad769b375b3f20afb4c3ffe6595fa7543fb47fb30c6e4f0b89bebdefcb2d'
end
