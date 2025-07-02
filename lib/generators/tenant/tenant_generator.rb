# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'rails/generators'

class TenantGenerator < Rails::Generators::NamedBase
  def install_migrations
    return unless generating?

    rails_command "schematics:copy:migrations DATABASE=#{name}", env:
  end

  def encrypt_database
    return unless env.on_premise?
    return unless generating?

    rails_command 'schematics:db:encryption:init', env:
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

    rails_command "db:seed DATABASE=#{name}", env:
  end

  def load_fixtures
    return unless env.development?
    return unless generating?

    rails_command "db:fixtures:load FIXTURES_PATH='../fixtures' DATABASE=#{name}", env:
  end

  def drop_databases
    return unless destroying?

    FileUtils.rm_rf("storage/#{name}")
    `dropdb #{name}_#{env}`
  end

  def destroy_migrations
    return unless destroying?

    FileUtils.rm_rf("db/#{name}")
  end

  private

  def generating?
    behavior == :invoke
  end

  def env
    return 'test'.inquiry if ENV['CI'].present?
    return 'development'.inquiry if Dir.pwd.end_with?('schematics')
    return 'on_premise'.inquiry if Dir.pwd.end_with?('on-premise')

    'production'.inquiry
  end

  def destroying?
    behavior == :revoke
  end
end
