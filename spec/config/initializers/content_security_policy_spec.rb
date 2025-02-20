# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Content Security Policy initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/content_security_policy.rb.tt', # rubocop:disable Layout/LineLength
                  '74c222dfd7c82fb1797dbe8eb4fce7b9e6afdfea8e413957692a021dfd7bfbb0'
end
