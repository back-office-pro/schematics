# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'CORS initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/cors.rb.tt',
                  '3d2204f77bb83b40940ae789f0201a66d0f40a55a9144d51f28c433d8eb0d1bd'
end
