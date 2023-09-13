# frozen_string_literal: true

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  '16140e9a376198e4a05ed60575ffd1219f3a34c405bab34683c850e5effe0ce3'
end
