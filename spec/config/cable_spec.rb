# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Cable config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/cable.yml.tt',
                  'a5e777599ba4e631e5c12afc36da3a11e5f6ab06bac90feb8386f4bafab8caa0'
end
