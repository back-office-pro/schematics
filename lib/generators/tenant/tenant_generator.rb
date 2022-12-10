# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'pg'

class TenantGenerator < Rails::Generators::NamedBase
  def create_postgres_user
    ::PG
      .connect
      .exec("CREATE USER #{name} WITH ENCRYPTED PASSWORD '#{db_password}' CREATEDB")
  rescue PG::Error
    nil
  end

  def install_migrations
    rails_command 'schematics:install:migrations'
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

  def generate_api_docs
    rails_command 'schematics:docs:generate', env:
  end

  def load_schemadataset_fixture
    return unless env.development?

    rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets'
  end

  def reindex_searchkick
    return if container?

    rails_command 'searchkick:reindex:all', env:
  end

  private

  def db_password = options[:db_password]

  def env = ENV
    .fetch('RAILS_ENV', 'production')
    .inquiry

  def container? = false
end
