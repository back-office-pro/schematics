# frozen_string_literal: true

require 'json'

# Gems
gem 'schematics', path: '/Users/max/github/schematics'
gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'

after_bundle do
  # Rails commands
  rails_command 'generate simple_form:install --bootstrap'
  rails_command 'generate rspec:install'
  rails_command 'generate strong_migrations:install'
  rails_command 'schematics:install:migrations'
  rails_command 'active_storage:install'
  rails_command 'action_text:install'
  rails_command 'schematics:generate'
  rails_command 'generate model search query:string model:string filters:jsonb user:references --no-test-framework' # rubocop:disable Layout/LineLength
  rails_command 'generate annotate:install'
  rails_command 'generate erd:install'
  rails_command 'db:reset'
  rails_command 'db:migrate'
  rails_command 'db:fixtures:load FIXTURES_PATH="spec/fixtures" FIXTURES=users,active_storage/attachments,active_storage/blobs,roles,charts,stats,clients,sub_categories,categories,products,orders' # rubocop:disable Layout/LineLength
  rails_command 'schematics:db:seed'
  rails_command 'schematics:docs:generate'
  rails_command 'schematics:licence:renew[enterprise,12]'
  rails_command 'schematics:users:admin[maxence.derous@gmail.com,John,Doe,fr,Paris]'
  rails_command 'dev:cache'

  # Ignore /doc directory
  append_to_file '.gitignore', '/doc'

  # Remove public html files
  remove_file 'public/404.html'
  remove_file 'public/422.html'
  remove_file 'public/500.html'

  # Remove /test directory
  remove_dir 'test'

  # Yarn packages
  JSON
    .parse(File.read((File.expand_path('package.json', __dir__))))
    .fetch('dependencies')
    .each { |dependency, version| run "yarn add #{dependency}@#{version}" }

  # Git
  git add: '-A'
  git commit: "-m 'initial commit'"

  # Security
  run 'brakeman --no-pager --no-exit-on-error'

  # Tests
  run 'rspec'

  # Database checks
  rails_command 'schematics:db:active_record_doctor'
  rails_command 'schematics:db:consistency'
end
