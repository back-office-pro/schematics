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

  def run_bundle
    add_gem
    super
  end

  def create_env_file
    template '.env'
  end

  def create_github_workflow_file
    template 'github/workflows/build.yml', '.github/workflows/build.yml'
  end

  def create_puppeteer_config_file
    template File.join(root_path, '.puppeteerrc.cjs'), '.puppeteerrc.cjs'
  end

  def create_nginx_config_file
    template 'config/nginx.conf'
  end

  def edit_storage_configuration
    append_file 'config/storage.yml', <<~YAML
      amazon:
        service: TenantS3
        access_key_id: <%= Schematics::Engine.credentials.dig(:aws, :access_key_id) %>
        secret_access_key: <%= Schematics::Engine.credentials.dig(:aws, :secret_access_key) %>
        region: us-east-1
        bucket: back-office.pro
    YAML
  end

  def install_rspec
    rails_command 'generate rspec:install'
  end

  def install_migrations
    rails_command 'schematics:install:migrations'
  end

  def install_good_job
    return unless ENV['STORAGE'] == 'postgresql'

    rails_command 'generate good_job:install'
  end

  def install_active_storage
    rails_command 'active_storage:install'
  end

  def install_action_text
    rails_command 'action_text:install'
  end

  def reset_database
    return if container?

    rails_command 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 db:reset', env:
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
      /.cache
      /.env
      /node_modules
    TEXT
  end

  def remove_public_html_files
    remove_file 'public/404.html'
    remove_file 'public/422.html'
    remove_file 'public/500.html'
  end

  def remove_unused_files
    remove_file 'app/javascript/controllers/hello_controller.js'
    remove_file 'config/locales/en.yml'
  end

  def run_yarn_init
    run 'yarn init -yp'
  end

  def add_yarn_dependencies = ::JSON
    .parse(File.read(File.join(root_path, 'package.json')))
    .fetch('dependencies')
    .each { |dependency, version| run "yarn add #{dependency}@#{version}" }

  def precompile_assets
    return unless env.production?

    rails_command 'assets:precompile', env:
  end

  def create_initial_commit
    git add: '-A'
    git commit: "-m 'initial commit'"
    git branch: '-M main'
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

  def deploy_nginx_subdomain
    return if container?
    return if env.development?
    return unless nginx?

    rails_command 'schematics:nginx:deploy', env:
  end

  def run_application
    return if container?
    return if env.development?

    rails_command 'server &', env:
  end

  private

  def source_paths
    super.unshift File.expand_path('templates', __dir__)
  end

  def env = (app_path == 'spec/dummy' ? 'development' : 'production').inquiry

  def default_options = {
    database: 'postgresql',
    skip_keeps: true,
    skip_test: true
  }

  def db_name = app_name.underscore

  def db_password
    @db_password ||= SecureRandom.base58
  end

  def container? = options[:container]

  def root_path = File.expand_path('../../..', __dir__)

  def gem_path
    return '/app' if container?
    return root_path if env.development?
  end

  def add_gem
    gem 'schematics', **{ path: gem_path }.compact
  end

  def clean_app_path
    FileUtils.rm_rf app_path
  end

  def create_postgres_user
    ::PG
      .connect
      .exec("CREATE USER #{db_name} WITH ENCRYPTED PASSWORD '#{db_password}' CREATEDB")
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

  def https? = Dir.exist?('/etc/letsencrypt/live')

  def nginx? = Dir.exist?('/etc/nginx')
end
