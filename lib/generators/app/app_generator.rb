# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/securerandom'
require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'json'
require 'rails/generators/rails/app/app_generator'

# :reek:RepeatedConditional
class AppGenerator < Rails::Generators::AppGenerator # rubocop:disable Metrics/ClassLength
  source_root superclass.source_root

  def initialize(generator, options = {})
    super(generator, options.merge(default_options), options)
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

  def create_docker_entrypoint_file
    template 'docker-entrypoint', 'bin/docker-entrypoint'
    chmod 'bin/docker-entrypoint', 0o755 & ~File.umask, verbose: false
  end

  def install_migrations
    return unless generating?

    rails_command 'schematics:install:migrations', env:
  end

  def install_search_migrations
    return unless generating?

    rails_command 'schematics:install:migrations DATABASE=search MIGRATIONS_PATH=db/search_migrate', env: # rubocop:disable Layout/LineLength
  end

  def create_database
    return if container?
    return unless generating?

    rails_command 'db:create', env:
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

  def install_solid_queue
    return unless generating?

    remove_file 'db/queue_schema.rb'
    rails_command('solid_queue:install', env:)
    remove_file 'config/queue.yml'
    remove_file 'config/recurring.yml'
  end

  def install_solid_cache
    return unless generating?

    remove_file 'db/cache_schema.rb'
    rails_command('solid_cache:install', env:)
    remove_file 'config/cache.yml'
  end

  def install_solid_cable
    return unless generating?

    remove_file 'db/cable_schema.rb'
    rails_command('solid_cable:install', env:)
    remove_file 'config/cable.yml'
  end

  def prepare_database
    return if container?
    return unless generating?

    rails_command 'db:prepare', env:
  end

  def load_subscription
    return if container?
    return unless generating?

    rails_command 'schematics:subscription:load', env:
  end

  def seed_database
    return if container?
    return unless generating?

    rails_command "schematics:db:seed NAME=#{app_name}", env:
  end

  def backup_credentials
    return if container?
    return unless generating?

    rails_command 'schematics:credentials:backup', env:
  end

  def load_fixtures
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
    remove_file '.github/dependabot.yml'
    remove_file 'app/assets/stylesheets/application.css'
    remove_file 'app/controllers/application_controller.rb'
    remove_file 'app/helpers/application_helper.rb'
    remove_file 'app/views/layouts/application.html.erb'
    remove_file 'app/views/pwa/manifest.json.erb'
    remove_file 'app/views/pwa/service-worker.js'
    remove_file 'bin/bundle'
    remove_file 'bin/dev'
    remove_file 'bin/jobs'
    remove_file 'bin/rake'
    remove_file 'bin/setup'
    remove_file 'config/initializers/content_security_policy.rb'
    remove_file 'config/initializers/filter_parameter_logging.rb'
    remove_file 'config/initializers/inflections.rb'
    remove_file 'config/locales/en.yml'
    remove_file 'config/puma.rb'
    remove_file 'config/routes.rb'
    remove_file 'config/environments/development.rb'
    remove_file 'config/environments/production.rb'
    remove_file 'config/environments/test.rb'
    remove_file 'public/400.html'
    remove_file 'public/404.html'
    remove_file 'public/406-unsupported-browser.html'
    remove_file 'public/422.html'
    remove_file 'public/500.html'
    remove_file 'public/icon.png'
    remove_file 'public/icon.svg'
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

    rails_command "generate repository #{app_name}", env:
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

    rails_command "generate systemd #{app_name}", env:
  end

  def deploy_nginx_subdomain
    return if container?
    return if env.development?
    return unless generating?

    rails_command "generate nginx #{app_name}", env:
  end

  def destroy_root
    FileUtils.rm_rf(app_path) if destroying?
  end

  private

  def default_options = {
    database: 'sqlite3',
    skip_test: true,
    skip_keeps: true,
    skip_javascript: true,
    skip_docker: true,
    skip_active_job: true,
    skip_action_cable: true,
    skip_active_record: true,
    skip_asset_pipeline: true,
    skip_rubocop: true,
    skip_brakeman: true,
    skip_thruster: true,
    skip_kamal: true
  }

  def generating?
    behavior == :invoke
  end

  def destroy_github_repo
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy repository #{app_name}`
  end

  def env = (app_path == 'spec/demo' ? 'development' : 'production').inquiry

  def destroy_systemd_service
    return if container?
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy systemd #{app_name}`
  end

  def container? = options[:container]

  def destroy_nginx_subdomain
    return if container?
    return if env.development?

    `cd #{app_path} && RAILS_ENV=#{env} rails destroy nginx #{app_name}`
  end

  def drop_database
    `cd #{app_path} && RAILS_ENV=#{env} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop`
  end

  def destroying?
    behavior == :revoke
  end

  def source_paths
    super.unshift File.expand_path('templates', __dir__)
  end

  def root_path = File.expand_path('../../..', __dir__)
end
