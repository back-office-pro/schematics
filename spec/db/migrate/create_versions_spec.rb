# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'
require 'paper_trail'

describe 'PaperTrail versions migration file' do
  it_behaves_like 'an overridden file',
                  :paper_trail,
                  '/lib/generators/paper_trail/install/templates/create_versions.rb.erb',
                  '1b57f85e084cbe57e089b966f52581ea50dd21d1aa454c28fabedd56e871a819'
end
