# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'

describe 'Rails create table migration template' do
  it_behaves_like 'an overridden file',
                  :activerecord,
                  '/lib/rails/generators/active_record/migration/templates/create_table_migration.rb.tt', # rubocop:disable Layout/LineLength
                  '7bd1bb304333b81177dd5c913bbe08741ac77f3c210807e0f366156be349cf40'
end
