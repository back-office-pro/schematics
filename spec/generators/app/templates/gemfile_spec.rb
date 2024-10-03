# frozen_string_literal: true

require 'rails'

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  'de63a152f8bb39b9e3514dab90723ae937dd7e79ab310d8ec1dd9ca1c3c80f6d'
end
