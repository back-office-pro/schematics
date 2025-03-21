# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  'c4c635754ea2642a9bf6587c63fc6fba050fb31b04fdf9f320b220c51f246f0d'
end
