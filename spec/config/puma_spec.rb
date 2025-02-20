# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  'a46fd60290a33526f7dc606d60f56d5143096c075a5878137a7edb197ee4cfcf'
end
