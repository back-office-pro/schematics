# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'fileutils'
require 'rails/generators'

class TenantGenerator < Rails::Generators::NamedBase
  def create_database
    return unless generating?

    rails_command "db:create DATABASE=#{name}", env:
  end

  def generate_schematics
    return unless generating?

    rails_command "schematics:generate DATABASE=#{name}", env:
  end

  def load_database_schema
    return unless generating?

    rails_command "db:schema:load DATABASE=#{name}", env:
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

    rails_command "db:fixtures:load FIXTURES_PATH='spec/fixtures' DATABASE=#{name}", env:
  end

  def drop_database_schemas
    return unless destroying?

    FileUtils.rm_rf %w[db/schema.rb db/search_schema.rb]
  end

  def drop_databases
    return unless destroying?

    FileUtils.rm_rf("storage/#{name}")
    `dropdb #{name}_#{env}`
  end

  private

  def generating?
    behavior == :invoke
  end

  def env
    return 'test'.inquiry if ENV['CI'].present?
    return 'production'.inquiry if ENV['RAILS_ENV'] == 'production'

    'development'.inquiry
  end

  def destroying?
    behavior == :revoke
  end
end
