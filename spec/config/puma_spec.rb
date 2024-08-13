# frozen_string_literal: true

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  'cda9cc6b697789c2605073183543c7d84506c7dffcf378af3cb9fe573b079420'
end
