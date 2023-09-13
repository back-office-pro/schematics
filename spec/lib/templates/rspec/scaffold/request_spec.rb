# frozen_string_literal: true

describe 'RSpec Request spec template' do
  it_behaves_like 'an overridden file',
                  'rspec-rails',
                  '/lib/generators/rspec/scaffold/templates/request_spec.rb',
                  'eddd62673ec69cd38c0a8d961a141688199cfb89ee2fe6b737c9ee053fae9bf2'
end
