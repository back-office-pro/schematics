# frozen_string_literal: true

describe 'Application config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/application.rb.tt',
                  '3f5ea9fd7915f9bf6ccf7e0643c4ab42d9d7ebe742946c43483a458311d1b80a'
end
