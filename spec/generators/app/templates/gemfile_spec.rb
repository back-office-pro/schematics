# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  'a543719c75da5cce2cbe72475a8cb55958ca205f78e2ff5dbbc60d7da0c41ddc'
end
