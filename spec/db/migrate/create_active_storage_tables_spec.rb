# frozen_string_literal: true

require 'openssl'
require 'active_storage'

describe 'ActiveStorage migration file' do
  it_behaves_like 'an overridden file',
                  :activestorage,
                  '/db/migrate/20170806125915_create_active_storage_tables.rb',
                  'a8dd8d8230c28494f1de2e51fb31a45ccfe1f6be1f1f816ad9e184d4783d60ac'
end
