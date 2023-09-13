# frozen_string_literal: true

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  '9dec0caefce77b4c028298efe984003a35163b2f347da6d1395749856c46583b'
end
