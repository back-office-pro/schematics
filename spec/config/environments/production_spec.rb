# frozen_string_literal: true

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '35f08a9a63cf252c2459cec03a7c72438b3a040ac1e0e1cd243e833346288b2a'
end
