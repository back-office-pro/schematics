# frozen_string_literal: true

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  '61350aa0d2a4916c84e43bc0c21bab7150398fa128e265dcea94ef41a94427cd'
end
