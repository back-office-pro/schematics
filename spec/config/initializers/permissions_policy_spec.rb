# frozen_string_literal: true

require 'rails'

describe 'Permissions policy initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/permissions_policy.rb.tt', # rubocop:disable Layout/LineLength
                  '57964ae15b5c99f55fe9cceb51d70073400878bf9ea26cb11f072e357aed9522'
end
