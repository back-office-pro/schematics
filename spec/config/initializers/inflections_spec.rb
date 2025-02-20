# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Inflections initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/inflections.rb.tt',
                  'e2c18b803625a073b25e4ee4460677da33a8bf19bbbcad629718a8e15c58acc2'
end
