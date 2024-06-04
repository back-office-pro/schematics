# frozen_string_literal: true

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '180f80fb84129f7f53122672158ee5cd61b2a3f0dd6944524c21e6c7134fd819'
end
