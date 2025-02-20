# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'friendly_id'

describe 'FriendlyId slugs migration file' do
  it_behaves_like 'an overridden file',
                  :friendly_id,
                  '/lib/friendly_id/migration.rb',
                  'db55b2ec67152018bfde0091b552375cc909915cf7a0e2cd22a2e8b96f24981a'
end
