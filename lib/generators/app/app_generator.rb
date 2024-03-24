# frozen_string_literal: true

require 'active_support/core_ext/securerandom'
require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'json'
require 'pg'
require 'rails/generators/rails/app/app_generator'

# :reek:RepeatedConditional
class AppGenerator < Rails::Generators::AppGenerator # rubocop:disable Metrics/ClassLength
  source_root superclass.source_root

  def initialize(generator, options = {})
    super(generator, options.merge(default_options), options)
  end

  def create_postgres_user
    return if container?
    return unless generating?

    pg_exec("CREATE USER #{db_username} WITH ENCRYPTED PASSWORD '#{db_password}' CREATEDB")
  end

  def create_root
    return super if generating?

    destroy_github_repo
    destroy_systemd_service
    destroy_nginx_subdomain
    drop_database
  end

  def bundle_install?
    super if generating?
  end

  def create_master_key
    super if generating?
  end

  def create_credentials
    super if generating?
  end

  def create_env_file
    template '.env'
  end

  def create_docker_entrypoint_file
    template 'docker-entrypoint', 'bin/docker-entrypoint'
    chmod 'bin/docker-entrypoint', 0o755 & ~File.umask, verbose: false
  end

  def create_github_workflow_file
    template 'github/workflows/build.yml', '.github/workflows/build.yml'
  end

  def install_migrations
    return unless generating?

    rails_command 'schematics:install:migrations', env:
  end

  def install_solid_queue
    return unless generating?

    rails_command 'solid_queue:install:migrations', env:
  end

  def install_solid_cache
    return unless generating?

    rails_command 'solid_cache:install:migrations', env:
  end

  def create_database
    return if container?
    return unless generating?

    rails_command 'db:create', env:
  end

  def drop_postgres_user
    return if container?
    return unless destroying?

    pg_exec("DROP USER #{db_username}")
  end

  def store_database_password
    return if container?
    return unless generating?

    rails_command "schematics:db:password[#{db_password}]", env:
  end

  def generate_schematics
    return unless generating?

    rails_command 'schematics:generate', env:
  end

  def encrypt_database
    return unless generating?

    rails_command 'schematics:db:encryption:init', env:
  end

  def migrate_database
    return if container?
    return unless generating?

    rails_command 'db:migrate', env:
  end

  def load_subscription
    return if container?
    return unless generating?

    rails_command 'schematics:subscription:load', env:
  end

  def seed_database
    return if container?
    return unless generating?

    rails_command 'schematics:db:seed', env:
  end

  def backup_credentials
    return if container?
    return unless generating?

    rails_command 'schematics:credentials:backup', env:
  end

  def load_migration_fixture
    return if container?
    return unless env.development?
    return unless generating?

    rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures"', env:
  end

  def edit_gitignore
    return unless generating?

    append_to_file '.gitignore', <<~TEXT
      /Gemfile.lock
    TEXT
  end

  def remove_unused_files
    remove_file 'app/assets/stylesheets/application.css'
    remove_file 'app/controllers/application_controller.rb'
    remove_file 'app/helpers/application_helper.rb'
    remove_file 'app/views/layouts/application.html.erb'
    remove_file 'bin/bundle'
    remove_file 'bin/rake'
    remove_file 'bin/setup'
    remove_file 'config/initializers/content_security_policy.rb'
    remove_file 'config/initializers/filter_parameter_logging.rb'
    remove_file 'config/initializers/inflections.rb'
    remove_file 'config/initializers/permissions_policy.rb'
    remove_file 'config/locales/en.yml'
    remove_file 'config/puma.rb'
    remove_file 'config/routes.rb'
    remove_file 'config/environments/development.rb'
    remove_file 'config/environments/production.rb'
    remove_file 'config/environments/test.rb'
    remove_file 'public/404.html'
    remove_file 'public/422.html'
    remove_file 'public/500.html'
    remove_file 'public/apple-touch-icon-precomposed.png'
    remove_file 'public/apple-touch-icon.png'
    remove_file 'public/favicon.ico'
    remove_file 'public/robots.txt'
    remove_file '.gitattributes'
    remove_file '.ruby-version'
    remove_file 'README.md'
  end

  def precompile_assets
    return unless env.production?
    return unless generating?

    rails_command 'assets:precompile', env:
  end

  def create_initial_commit
    return unless generating?

    git add: '-A'
    git commit: "-m 'initial commit'"
    git branch: '-M main'
    git clean: '-f -d'
  end

  def create_github_repo
    return if env.development?
    return unless generating?

    rails_command 'generate repository', env:
  end

  def add_remote_to_repo
    return if env.development?
    return unless generating?

    git remote: "add origin git@github.com:back-office-pro/#{app_name}.git"
  end

  def push_repo_to_origin
    return if env.development?
    return unless generating?

    git push: '-u origin main'
  end

  def deploy_systemd_service
    return if container?
    return if env.development?
    return unless generating?

    rails_command 'generate systemd', env:
  end

  def deploy_nginx_subdomain
    return if container?
    return if env.development?
    return unless generating?

    rails_command 'generate nginx', env:
  end

  def destroy_root
    FileUtils.rm_rf(app_path) if destroying?
  end

  private

  def generating?
    behavior == :invoke
  end

  def destroying?
    behavior == :revoke
  end

  def source_paths
    super.unshift File.expand_path('templates', __dir__)
  end

  def env = (app_path == 'spec/demo' ? 'development' : 'production').inquiry

  def default_options = {
    database: 'postgresql',
    skip_test: true,
    skip_keeps: true,
    skip_javascript: true,
    skip_hotwire: true,
    skip_docker: true,
    skip_action_mailer: true,
    skip_active_job: true,
    skip_action_cable: true,
    skip_active_record: true,
    skip_asset_pipeline: true
  }

  def db_username = app_name.underscore

  def db_password
    @db_password ||= SecureRandom.base58
  end

  def container? = options[:container]

  def root_path = File.expand_path('../../..', __dir__)

  def pg_exec(query)
    ::PG
      .connect(connect_timeout: 1)
      .exec(query)
  end

  def drop_database
    `cd #{app_path} && RAILS_ENV=#{env} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop`
  end

  def destroy_github_repo
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy repository`
  end

  def destroy_systemd_service
    return if container?
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy systemd`
  end

  def destroy_nginx_subdomain
    return if container?
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy nginx`
  end
end
