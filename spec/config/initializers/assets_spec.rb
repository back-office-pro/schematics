# frozen_string_literal: true

describe 'Assets initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/assets.rb.tt',
                  '20f062d56f4c011acee69f16fd2ee1bec9de0245a2d401599fa884bf19ee4c7f'
end
