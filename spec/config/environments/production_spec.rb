# frozen_string_literal: true

require 'rails'

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  '3bc56fc79e40ebeec38539a09e290b0457fdd5a514416dc70abf6f5abf1fbaac'
end
