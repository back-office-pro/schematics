# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
