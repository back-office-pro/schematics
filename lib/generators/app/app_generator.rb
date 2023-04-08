# frozen_string_literal: true

require 'active_support/core_ext/securerandom'
require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'json'
require 'pg'
require 'rails/generators/rails/app/app_generator'

class AppGenerator < Rails::Generators::AppGenerator # rubocop:disable Metrics/ClassLength
  DEFAULT_PORT = 3000
  source_root superclass.source_root

  def initialize(generator, options = {})
    super generator, options.merge(default_options)
  end

  def create_root
    create_postgres_user
    clean_app_path
    super
  end

  def create_env_file
    template '.env'
  end

  def create_github_workflow_file
    template 'github/workflows/build.yml', '.github/workflows/build.yml'
  end

  def install_rspec
    rails_command 'generate rspec:install'
  end

  def install_migrations
    rails_command 'schematics:install:migrations'
  end

  def install_good_job
    rails_command 'generate good_job:install'
  end

  def install_active_storage
    rails_command 'active_storage:install'
  end

  def install_action_text
    rails_command 'action_text:install:migrations'
  end

  def reset_database
    return if container?

    rails_command 'db:reset', env:
  end

  def generate_schematics
    rails_command 'schematics:generate'
  end

  def encrypt_database
    rails_command 'schematics:db:encryption:init', env:
  end

  def migrate_database
    return if container?

    rails_command 'db:migrate', env:
  end

  def load_licence
    return if container?

    rails_command 'schematics:licence:load', env:
  end

  def seed_database
    return if container?

    rails_command 'schematics:db:seed', env:
  end

  def backup_credentials
    rails_command 'schematics:credentials:backup', env:
  end

  def load_schemadataset_fixture
    return unless env.development?

    rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets'
  end

  def reindex_searchkick
    return if container?

    rails_command 'searchkick:reindex:all', env:
  end

  def edit_gitignore
    append_to_file '.gitignore', <<~TEXT
      /.env
      /node_modules
    TEXT
  end

  def edit_application_mailer
    comment_lines 'app/mailers/application_mailer.rb', /default from:/
    comment_lines 'app/mailers/application_mailer.rb', /layout/
  end

  def remove_unused_files
    remove_file 'app/assets/stylesheets/application.css'
    remove_file 'app/helpers/application_helper.rb'
    remove_file 'app/views/layouts/application.html.erb'
    remove_file 'app/views/layouts/mailer.html.erb'
    remove_file 'app/views/layouts/mailer.text.erb'
    remove_file 'config/initializers/content_security_policy.rb'
    remove_file 'config/initializers/filter_parameter_logging.rb'
    remove_file 'config/initializers/inflections.rb'
    remove_file 'config/initializers/permissions_policy.rb'
    remove_file 'config/locales/en.yml'
    remove_file 'config/cable.yml'
    remove_file 'config/database.yml'
    remove_file 'config/storage.yml'
    remove_file 'config/puma.rb'
    remove_file 'config/routes.rb'
    remove_file 'config/environments/development.rb'
    remove_file 'config/environments/production.rb'
    remove_file 'config/environments/test.rb'
    remove_file 'db/seeds.rb'
    remove_file '.gitattributes'
    remove_file '.rspec'
    remove_file '.ruby-version'
    remove_file 'README.md'
  end

  def precompile_assets
    return unless env.production?

    rails_command 'assets:precompile', env:
  end

  def create_initial_commit
    git add: '-A'
    git commit: "-m 'initial commit'"
    git branch: '-M main'
    git clean: '-f -d'
  end

  def create_github_repo
    return if env.development?

    rails_command 'schematics:repo:create', env:
  end

  def add_remote_to_repo
    return if env.development?

    git remote: "add origin git@github.com:back-office-pro/#{app_name}.git"
  end

  def push_repo_to_origin
    return if env.development?

    git push: '-u origin main'
  end

  def deploy_systemd_service
    return if container?
    return if env.development?
    return unless Dir.exist?('/etc/systemd')

    rails_command 'schematics:systemd:deploy', env:
  end

  def deploy_nginx_subdomain
    return if container?
    return if env.development?
    return unless Dir.exist?('/etc/nginx')

    rails_command 'schematics:nginx:deploy', env:
  end

  private

  def source_paths
    super.unshift File.expand_path('templates', __dir__)
  end

  def env = (app_path == 'spec/demo' ? 'development' : 'production').inquiry

  def default_options = {
    database: 'postgresql',
    skip_test: true,
    skip_keeps: true,
    skip_javascript: true,
    skip_asset_pipeline: true
  }

  def db_username = app_name.underscore

  def db_password
    @db_password ||= SecureRandom.base58
  end

  def container? = options[:container]

  def root_path = File.expand_path('../../..', __dir__)

  def clean_app_path
    FileUtils.rm_rf app_path
  end

  def create_postgres_user
    ::PG
      .connect
      .exec("CREATE USER #{db_username} WITH ENCRYPTED PASSWORD '#{db_password}' CREATEDB")
  rescue PG::Error
    nil
  end

  def database_index = ::PG
    .connect
    .exec("SELECT COUNT(datname) FROM pg_database WHERE datname LIKE '%_#{env}'")
    .getvalue(0, 0)
    .to_i
    .next

  def port = DEFAULT_PORT + database_index
end
