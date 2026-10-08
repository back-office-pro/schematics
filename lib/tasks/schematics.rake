# frozen_string_literal: true

namespace :schematics do
  desc 'Generate core application'
  task generate: :environment do
    unless Migration.table_exists?
      Schematics::Migrator
        .new
        .build_commands
        .flat_map(&:generators)
        .each(&:invoke_all)
    end
  end

  desc 'Update core application'
  task update: :environment do
    if Schematics::SchemaCache.outdated?
      PaperTrail.request(enabled: false) do
        Core::Migrations::Migrate.call(migration: Migration.core)
      end
    end
  end

  desc 'Generate application secret key base'
  task secret_key_base: :environment do
    secret = "secret_key_base: #{SecureRandom.hex(64)}"
    credentials = Rails.application.credentials
    credentials.write(credentials.read + secret) unless credentials.secret_key_base
  end
end
