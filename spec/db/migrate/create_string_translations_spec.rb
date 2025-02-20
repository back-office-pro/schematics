# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'mobility'

describe 'Mobility string translations migration file' do
  it_behaves_like 'an overridden file',
                  :mobility,
                  '/lib/rails/generators/mobility/templates/create_string_translations.rb',
                  'f29b83d9b8df8c479f5c08d4555bc4370384bc9f610e4bd3d0e769c084bb226e'
end
