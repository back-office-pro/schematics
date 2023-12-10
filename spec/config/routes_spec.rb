# frozen_string_literal: true

describe 'Routes config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/routes.rb.tt',
                  'b71bcdc6ccf7a27b4ee9bf39a05918b0bd89ee2bc69549d47ea2b43e681941bb'
end
