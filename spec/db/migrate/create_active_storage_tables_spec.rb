# frozen_string_literal: true

describe 'ActiveStorage migration file' do
  it_behaves_like 'an overridden file',
                  :activestorage,
                  '/db/migrate/20170806125915_create_active_storage_tables.rb',
                  '4f91ad857aabe2c4d824247d58dff047a52a7a422ce92cad63eb40e0fecd63e7'
end
