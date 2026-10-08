# frozen_string_literal: true

CI.run do
  step 'Rubocop', 'bundle exec rubocop'
  step 'Reek', 'bundle exec reek'
  step 'Slim lint', 'bundle exec slim-lint app'
  step 'i18n lint', 'bundle exec i18n-tasks health'
  step 'RSpec', 'bundle exec rspec ./spec/lib --require schematics'
  step 'Brakeman', 'bundle exec brakeman --no-pager --no-exit-on-error'
  step 'Bundler audit', 'bundle exec bundle-audit'
  step 'Stylelint', 'yarn stylelint'
  step 'StandardJS', 'yarn lint'
end
