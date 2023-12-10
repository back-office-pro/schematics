# frozen_string_literal: true

describe 'Filter parameter logging initializer file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/initializers/filter_parameter_logging.rb.tt', # rubocop:disable Layout/LineLength
                  '9b6423294c7f7e6f9601fe967053019e578efc87883d7159992579d2bbca71d6'
end
