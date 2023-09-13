# frozen_string_literal: true

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '3adc2ffb52c86a891613c2b470a9692dbbca69e7865e57ddb0cbf5bc52236ff0'
end
