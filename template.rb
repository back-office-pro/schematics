# frozen_string_literal: true

# Gems
gem 'schematics', path: '/Users/max/github/schematics'
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
  rails_command 'db:migrate:reset'
  rails_command 'db:fixtures:load' if options[:skip_listen]
  rails_command 'schematics:db:seed'
  rails_command 'schematics:docs:generate'
  rails_command 'schematics:licence:renew[enterprise,12]'
  rails_command 'dev:cache' if options[:skip_listen]

  # Ignore /doc directory
  append_to_file '.gitignore', '/doc'

  # Remove public html files
  remove_file 'public/404.html'
  remove_file 'public/422.html'
  remove_file 'public/500.html'

  # Yarn packages
  run 'yarn add animate.css@4.1.1'
  run 'yarn add bootstrap@4.6.0'
  run 'yarn add bootswatch@4.6.0'
  run 'yarn add file-saver@2.0.5'
  run 'yarn add flag-icon-css@3.5.0'
  run 'yarn add jquery@3.5.1'
  run 'yarn add jquery-resizable-columns@0.2.3'
  run 'yarn add jquery-ui@1.12.1'
  run 'yarn add jquery-ujs@1.2.2'
  run 'yarn add slim-select@1.27.0'
  run 'yarn add sortablejs@1.14.0'
  run 'yarn add stimulus@2.0.0'
  run 'yarn add sweetalert2@5.1.1'

  # Git
  git add: '-A'
  git commit: "-m 'initial commit'"

  # Security
  run 'brakeman --no-pager --no-exit-on-error'

  # Tests
  run 'rake test'
end
