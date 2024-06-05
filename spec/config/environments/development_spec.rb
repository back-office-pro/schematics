# frozen_string_literal: true

describe 'Development environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/development.rb.tt',
                  '1a4f9b1b2827bf8d791de80e7db536d877921ab8f053ea6c0f6775ec835f45c6'
end
