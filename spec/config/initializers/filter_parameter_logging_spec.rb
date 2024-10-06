# frozen_string_literal: true

require 'rails'

describe 'Filter parameter logging initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/filter_parameter_logging.rb.tt', # rubocop:disable Layout/LineLength
                  '7148ec031890b236867dfc35c38e7981d4f6ff8dd4323b6e8e87202187196826'
end
