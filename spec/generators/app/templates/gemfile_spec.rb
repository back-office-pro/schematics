# frozen_string_literal: true

require 'rails'

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  'a4c9272377f18955f2f698a36bb12c23052dfc98da135b9017f8f727322b77e9'
end
