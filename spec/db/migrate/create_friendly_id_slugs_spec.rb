# frozen_string_literal: true

require 'friendly_id'

describe 'FriendlyId slugs migration file' do
  it_behaves_like 'an overridden file',
                  :friendly_id,
                  '/lib/friendly_id/migration.rb',
                  '06607c74d2d2f512de4db32d206c345a043448e9cd18bd14c4c1c1f81944c5d0'
end
