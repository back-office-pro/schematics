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

  # Storage configuration
  append_file 'config/storage.yml', <<~YAML
    amazon:
      service: TenantS3
      access_key_id: <%= Schematics::Engine.credentials.dig(:aws, :access_key_id) %>
      secret_access_key: <%= Schematics::Engine.credentials.dig(:aws, :secret_access_key) %>
      region: us-east-1
      bucket: back-office.pro
  YAML

  # Rails commands
  rails_command 'generate simple_form:install --bootstrap'
  rails_command 'generate rspec:install'
  rails_command 'schematics:install:migrations'
  rails_command 'active_storage:install'
  rails_command 'action_text:install'
  rails_command('DISABLE_DATABASE_ENVIRONMENT_CHECK=1 db:reset', env:)
  rails_command 'schematics:generate'
  rails_command('schematics:db:encryption:init', env:)
  rails_command('db:migrate', env:)
  rails_command('schematics:db:seed', env:)
  rails_command('schematics:docs:generate', env:)
  rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets' if env.development? # rubocop:disable Layout/LineLength
  rails_command('searchkick:reindex:all', env:)

  # Edit .gitignore
  append_to_file '.gitignore', <<~TEXT
    /doc
    .env
  TEXT

  # Remove public HTML files
  remove_file 'public/404.html'
  remove_file 'public/422.html'
  remove_file 'public/500.html'

  # Remove unused files
  remove_file 'app/javascript/controllers/hello_controller.js'
  remove_file 'config/locales/en.yml'
  remove_file 'config/locales/simple_form.en.yml'

  # Yarn packages
  run 'yarn init -yp'

  JSON
    .parse(File.read((File.expand_path('package.json', __dir__))))
    .fetch('dependencies')
    .each { |dependency, version| run "yarn add #{dependency}@#{version}" }

  # Assets
  rails_command('assets:precompile', env:) if env.production?

  # Git
  git add: '-A'
  git commit: "-m 'initial commit'"

  # Security
  run 'brakeman --no-pager --no-exit-on-error'

  # Database checks
  rails_command('schematics:db:active_record_doctor', env:)
end
