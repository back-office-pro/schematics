# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'rails/generators/rails/app/app_generator'

# :reek:RepeatedConditional
class AppGenerator < Rails::Generators::AppGenerator
  source_root superclass.source_root

  def initialize(generator, options = {})
    super(generator, options.merge(default_options), options)
  end

  def create_root
    super if generating?
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
    return unless env.no_premise?

    template 'docker-entrypoint', 'bin/docker-entrypoint'
    chmod 'bin/docker-entrypoint', 0o755 & ~File.umask, verbose: false
  end

  def install_solid_queue
    return unless generating?

    rails_command 'solid_queue:install', env:
  end

  def install_solid_cache
    return unless generating?

    rails_command 'solid_cache:install', env:
  end

  def install_solid_cable
    return unless generating?

    rails_command 'solid_cable:install', env:
  end

  def remove_unused_files
    remove_file '.github'
    remove_file 'app'
    remove_file 'bin/bundle'
    remove_file 'bin/dev'
    remove_file 'bin/jobs'
    remove_file 'bin/rake'
    remove_file 'bin/setup'
    remove_file 'config/environments'
    remove_file 'config/initializers'
    remove_file 'config/locales'
    remove_file 'config/cable.yml'
    remove_file 'config/cache.yml'
    remove_file 'config/credentials.yml.enc'
    remove_file 'config/queue.yml'
    remove_file 'config/master.key' unless env.on_premise?
    remove_file 'config/puma.rb'
    remove_file 'config/recurring.yml'
    remove_file 'config/routes.rb'
    remove_file 'lib'
    remove_file 'public'
    remove_file 'script'
    remove_file 'storage'
    remove_file 'vendor'
    remove_file '.gitattributes'
    remove_file '.ruby-version'
    remove_file 'README.md'
  end

  def precompile_assets
    return if env.development?
    return unless generating?

    rails_command 'assets:precompile', env:
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

  def env
    return 'development'.inquiry if app_path == 'spec/demo'
    return 'on_premise'.inquiry if app_path == 'on-premise'

    'production'.inquiry
  end

  def destroying?
    behavior == :revoke
  end

  def source_paths
    super.unshift File.expand_path('templates', __dir__)
  end

  def root_path = File.expand_path('../../..', __dir__)
end
