# frozen_string_literal: true

describe 'Production environment config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/environments/production.rb.tt',
                  'd8bcd31ded98774a2b0303bec233e0bdcba075db8034d4cb3f5998a8785bfe49'
end
