# frozen_string_literal: true

describe 'Test environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/test.rb.tt',
                  '040fb10cc2925a65e7b2cebb41be499871f2f963424bc484d27fe8d76a411fb2'
end
