# frozen_string_literal: true

describe 'Application config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/application.rb.tt',
                  '4a0d5db7cf6c55517b520c0c52e52f143d1d225e69c63d701eb75b8cf7f4ebfe'
end
