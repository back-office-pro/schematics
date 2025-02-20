# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'

describe 'Rails Migration template' do
  it_behaves_like 'an overridden file',
                  :activerecord,
                  '/lib/rails/generators/active_record/migration/templates/migration.rb.tt',
                  '94b0f9ce285662d6812109de9e5d1a1d40d74f87f8ba1966f91f86b244ea76e6'
end
