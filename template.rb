# Gems
gem 'schematics', path: '/Users/max/bitbucket/schematics'
gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'

after_bundle do
  # Rails commands
  rails_command 'generate simple_form:install --bootstrap'
  rails_command 'generate rspec:install'
  rails_command 'schematics:install:migrations'
  rails_command 'schematics:generate'
  rails_command 'active_storage:install'
  rails_command 'action_text:install'
  rails_command 'generate annotate:install'
  rails_command 'generate fixtures'
  # rails_command 'generate locales'
  rails_command 'generate erd:install'
  rails_command 'generate open_api'
  rails_command 'db:migrate:reset', env: 'development'
  rails_command 'db:fixtures:load', env: 'development' if options[:skip_listen]
  rails_command 'schematics:db:seed', env: 'development'
  rails_command 'schematics:docs:generate', env: 'test'

  # Ignore /doc directory
  append_to_file '.gitignore', '/doc'

  # Yarn packages
  run 'yarn add animate.css@4.1.1'
  run 'yarn add bootstrap@4.6.0'
  run 'yarn add bootswatch@4.6.0'
  run 'yarn add jquery@3.5.1'
  run 'yarn add jquery-ui@^1.12.1'
  run 'yarn add jquery-ujs@^1.2.2'
  run 'yarn add typeahead.js@^0.11.1'
  run 'yarn add sweetalert2@5.1.1'
  run 'yarn add flag-icon-css@3.5.0'

  # Git
  git add: '-A'
  git commit: "-m 'initial commit'"

  # Security
  run 'brakeman --no-pager'

  # Best practices
  run 'rails_best_practices'

  # Tests
  run 'rake test'
end
