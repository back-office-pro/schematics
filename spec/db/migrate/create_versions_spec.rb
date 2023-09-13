# frozen_string_literal: true

describe 'PaperTrail versions migration file' do
  it_behaves_like 'an overridden file',
                  :paper_trail,
                  '/lib/generators/paper_trail/install/templates/create_versions.rb.erb',
                  '31f99e43a9ce9a7b5949cda116269addc83eff649f97906abf662a68192565bc'
end
