# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Filter parameter logging initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/filter_parameter_logging.rb.tt', # rubocop:disable Layout/LineLength
                  'f864bd67e7bdaa63a5331b9fc15446613c410c3a314cd70d1b6a7c8b566b6120'
end
