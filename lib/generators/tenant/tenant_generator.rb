# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'

class TenantGenerator < Rails::Generators::NamedBase
  def install_migrations
    empty_directory "db/#{name}_migrate"
    rails_command 'schematics:install:migrations'
    FileUtils.mv Dir.glob('db/migrate/*.rb'), "db/#{name}_migrate"
  end

  def reset_database
    rails_command "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 db:reset:#{name}", env:
  end

  def generate_schematics
    rails_command "TENANT=#{name} schematics:generate"
  end

  def migrate_database
    rails_command "db:migrate:#{name}", env:
  end

  def load_licence
    rails_command "TENANT=#{name} schematics:licence:load", env:
  end

  def seed_database
    rails_command "TENANT=#{name} schematics:db:seed", env:
  end

  def generate_api_docs
    rails_command "TENANT=#{name} schematics:docs:generate", env:
  end

  def load_schemadataset_fixture
    return unless env.development?

    # rails_command 'db:fixtures:load FIXTURES_PATH="../fixtures" FIXTURES=schema_datasets'
  end

  def reindex_searchkick
    rails_command 'searchkick:reindex:all', env:
  end

  def run_brakeman
    run 'brakeman --no-pager --no-exit-on-error'
  end

  def run_database_checks
    rails_command 'schematics:db:active_record_doctor', env:
  end

  private

  def env = ENV
    .fetch('RAILS_ENV', 'development')
    .inquiry
end
