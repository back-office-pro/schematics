# frozen_string_literal: true

describe 'Application config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/application.rb.tt',
                  '2d7814f6e7aef7b71f1142d20fcbeb173ed26493acd4a79f1390220791c8eee7'
end
