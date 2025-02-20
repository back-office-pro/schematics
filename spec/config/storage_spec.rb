# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Storage config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/storage.yml.tt',
                  '32827a1e913878352744614e49a42047718eb0b2b4aa634255496915635e1f94'
end
