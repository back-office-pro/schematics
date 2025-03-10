# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'rails/generators/named_base'

class TenantGenerator < Rails::Generators::NamedBase
  def install_migrations
    return unless generating?

    rails_command "schematics:copy:migrations DATABASE=#{name}", env:
  end

  def create_database
    return unless generating?

    rails_command "db:create DATABASE=#{name}", env:
  end

  def generate_schematics
    return unless generating?

    rails_command "schematics:generate DATABASE=#{name}", env:
  end

  def migrate_database
    return unless generating?

    rails_command "db:migrate DATABASE=#{name}", env:
  end

  def load_subscription
    return unless generating?

    rails_command "schematics:subscription:load DATABASE=#{name}", env:
  end

  def seed_database
    return unless generating?

    rails_command "schematics:db:seed DATABASE=#{name}", env:
  end

  def load_fixtures
    return unless env.development?
    return unless generating?

    rails_command "db:fixtures:load FIXTURES_PATH='../fixtures' DATABASE=#{name}", env:
  end

  def deploy_systemd_service
    return if env.development?
    return unless generating?

    rails_command "generate systemd #{name}", env:
  end

  def deploy_nginx_subdomain
    return if env.development?
    return unless generating?

    rails_command "generate nginx #{name}", env:
  end

  def destroy_systemd_service
    return unless destroying?
    return if env.development?

    `RAILS_ENV=#{env} rails destroy systemd #{name}`
  end

  def destroy_nginx_subdomain
    return unless destroying?
    return if env.development?

    `RAILS_ENV=#{env} rails destroy nginx #{name}`
  end

  def drop_database
    return unless destroying?

    `RAILS_ENV=#{env} DATABASE=#{name} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop`
  end

  def destroy_migrations
    return unless destroying?

    FileUtils.rm_rf("db/#{name}/migrate")
    FileUtils.rm_rf("db/#{name}/search_migrate")
  end

  private

  def generating?
    behavior == :invoke
  end

  def env = (Dir.pwd.end_with?('spec/demo') ? 'development' : 'production').inquiry

  def destroying?
    behavior == :revoke
  end
end
