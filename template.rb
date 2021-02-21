# Gems
gem "schematics", path: "/Users/max/bitbucket/schematics"
gem "best_in_place", git: "https://github.com/mmotherwell/best_in_place"
gem "date_validator", git: "https://github.com/codegram/date_validator", branch: "master"

after_bundle do
  # Rails commands
  rails_command "generate simple_form:install --bootstrap"
  rails_command "schematics:install:migrations"
  rails_command "schematics:generate"
  rails_command "active_storage:install"
  rails_command "action_text:install"
  rails_command "generate annotate:install"
  rails_command "generate fixtures"
  # rails_command "generate locales"
  rails_command "generate erd:install"
  rails_command "db:migrate:reset"
  rails_command "db:fixtures:load" if options[:skip_listen]
  rails_command "schematics:db:seed"
  rails_command "swagger:docs"

  # Git
  run "git add -A"
  run "git commit -m 'initial commit'"

  # Security
  run "brakeman --no-pager"

  # Best practices
  run "rails_best_practices"
end
