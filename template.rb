# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/string/inquiry'

# Set environment
env = (app_path == 'spec/dummy' ? 'development' : 'production').inquiry

# Gems
gem 'schematics', **{ path: (__dir__ if env.development?) }.compact
gem 'simple_form', # TODO: remove when simple_form is upgraded
    git: 'https://github.com/heartcombo/simple_form',
    branch: 'main'

after_bundle do
  # Environment file
  create_file '.env', "#{app_name.upcase}_DATABASE_PASSWORD=#{ENV.fetch('DATABASE_PASSWORD', nil)}"

  # Rails commands
  rails_command 'generate simple_form:install --bootstrap'
  rails_command 'generate rspec:install'
  rails_command 'schematics:install:migrations'
  rails_command 'active_storage:install'
  rails_command 'action_text:install'
  rails_command "RAILS_ENV=#{env} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 db:reset"
  rails_command 'schematics:generate'
  rails_command "RAILS_ENV=#{env} schematics:db:encryption:init"
  rails_command "RAILS_ENV=#{env} db:migrate"
  rails_command "RAILS_ENV=#{env} schematics:db:seed"
  rails_command "RAILS_ENV=#{env} schematics:docs:generate"
  rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets' if env.development? # rubocop:disable Layout/LineLength

  # Storage configuration
  append_file 'config/storage.yml', <<~YAML
    amazon:
      service: S3
      access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
      secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
      region: us-east-1
      bucket: back-office.pro
  YAML

  # Edit .gitignore
  append_to_file '.gitignore', <<~TEXT
    /doc
    /app/javascript/routes.js
    /migration_*.tar
  TEXT

  # Remove public HTML files
  remove_file 'public/404.html'
  remove_file 'public/422.html'
  remove_file 'public/500.html'

  # Yarn packages
  run 'yarn init -yp'

  JSON
    .parse(File.read((File.expand_path('package.json', __dir__))))
    .fetch('dependencies')
    .each { |dependency, version| run "yarn add #{dependency}@#{version}" }

  # Assets
  rails_command 'RAILS_ENV=production assets:precompile' if env.production?

  # Git
  git add: '-A'
  git commit: "-m 'initial commit'"

  # Security
  run 'brakeman --no-pager --no-exit-on-error'

  # Database checks
  rails_command "RAILS_ENV=#{env} schematics:db:active_record_doctor"
end
