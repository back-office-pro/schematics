# frozen_string_literal: true

describe 'ActiveStorage migration file' do
  it_behaves_like 'an overridden file',
                  :activestorage,
                  '/db/migrate/20170806125915_create_active_storage_tables.rb',
                  '4e929d49186c84aba844c8832d72d2f19b5cf5f9e81c30546857e84b1591183a'
end
