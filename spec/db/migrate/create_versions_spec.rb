# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'
require 'paper_trail'

describe 'PaperTrail versions migration file' do
  it_behaves_like 'an overridden file',
                  :paper_trail,
                  '/lib/generators/paper_trail/install/templates/create_versions.rb.erb',
                  'dc30da1fea142fc1b23daeb6a807144feae8fcba7246b73fd8cefc0c8b521a48'
end
