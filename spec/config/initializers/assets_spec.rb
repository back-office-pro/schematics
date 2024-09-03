# frozen_string_literal: true

describe 'Assets initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/assets.rb.tt',
                  'd20d91b802c286748b3b9958ba40f5ae65a9338b5f8eed326e4400feb2d9d83d'
end
