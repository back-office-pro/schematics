# Gems
gem "schematics", path: "/Users/max/bitbucket/schematics"

# Bundle
#run "bundle install"

# Schema
#copy_file "#{Dir.pwd}/../schema.json", "schema.json"

# Rails commands
rails_command "generate simple_form:install --bootstrap"
rails_command "schematics:generate"
rails_command "generate paper_trail:install --with-changes"
rails_command "active_storage:install"
rails_command "action_text:install"
rails_command "generate annotate:install"
rails_command "generate devise:install"
run "rails generate devise User"
rails_command "generate friendly_id"
rails_command "db:environment:set RAILS_ENV=development"
rails_command "db:migrate:reset"
rails_command "swagger:docs"

# Devise config
gsub_file "config/routes.rb", "devise_for :users", "devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' }"

# Git
run "git add -A"
run "git commit -m 'initial commit'"
