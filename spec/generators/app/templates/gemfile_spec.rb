# frozen_string_literal: true

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  '9363bc793285c4d83e5abe14cf36f8e1d620b561150e9f50a6e850d598aeef1b'
end
