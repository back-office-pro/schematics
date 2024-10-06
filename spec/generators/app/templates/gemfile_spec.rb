# frozen_string_literal: true

require 'rails'

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  '8a72eb3bab495cd69ae32befbe27afcdcad77eb6ffcdbc2ec6331674c8428182'
end
