# frozen_string_literal: true

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  'fabb13cdfe5f0adca6cf80728eed089cd3c11768e40e69b4f1ed2fa9c70ae2d1'
end
