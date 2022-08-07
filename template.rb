# frozen_string_literal: true

require 'json'

# Gems
gem 'schematics', path: '/Users/max/github/schematics'
gem 'simple_form', # TODO: remove when simple_form is upgraded
    git: 'https://github.com/heartcombo/simple_form',
    branch: 'main'

after_bundle do
  # Add main database configuration
  append_to_file 'config/database.yml', <<~YAML
    main:
      <<: *default
      database: backoffice_production
      username: readonly
      password: <%= ENV["MAIN_DATABASE_PASSWORD"] %>
      host: <%= ENV["MAIN_DATABASE_HOST"] %>
  YAML

  # Spring
  run 'bundle exec spring binstub --all'
  run 'bundle exec spring stop'
  run 'bin/spring server &'

  # Rails commands
  rails_command 'generate simple_form:install --bootstrap'
  rails_command 'generate rspec:install'
  rails_command 'generate strong_migrations:install'
  rails_command 'schematics:install:migrations'
  rails_command 'active_storage:install'
  rails_command 'action_text:install'
  rails_command 'db:reset'
  rails_command 'schematics:generate'
  rails_command 'schematics:db:encryption:init'
  rails_command 'generate annotate:install'
  rails_command 'generate erd:install'
  rails_command 'db:migrate'
  rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets'
  rails_command 'schematics:db:seed'
  rails_command 'schematics:docs:generate'
  rails_command 'js:routes'

  # Edit .gitignore
  append_to_file '.gitignore', '/doc'
  append_to_file '.gitignore', '/app/javascript/routes.js'

  # Remove public html files
  remove_file 'public/404.html'
  remove_file 'public/422.html'
  remove_file 'public/500.html'

  # Yarn packages
  run 'yarn init -yp'

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
end
