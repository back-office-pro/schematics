# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe 'Rails Scaffold Controller template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/scaffold_controller/templates/controller.rb.tt',
                  'e4c734902d2bd24750df09153743ac14f314528fcf533a4b8a6d19c768d89770'
end
