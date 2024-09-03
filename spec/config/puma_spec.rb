# frozen_string_literal: true

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  'cfe84d8cc244ffdee5e74eafc3d4bb19c55e2838b9960740899f7cbd9249df66'
end
