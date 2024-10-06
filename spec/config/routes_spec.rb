# frozen_string_literal: true

require 'rails'

describe 'Routes config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/routes.rb.tt',
                  '8516908a8c6a38534f4a354dbe9f0bccaee7db56b7acd22b2a3662429be35550'
end
