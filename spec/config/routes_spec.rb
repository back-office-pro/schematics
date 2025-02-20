# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Routes config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/routes.rb.tt',
                  '388e74019b9906322e7cb8be408270e12c80fd80797ea82aaafaa01c59b6bb6d'
end
