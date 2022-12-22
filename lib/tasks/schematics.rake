# frozen_string_literal: true

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Rails.application.load_generators
    Schematics::Migrations::CoreMigration
      .new(Tenant.schema)
      .build_commands
      .flat_map(&:generators)
      .each(&:invoke_all)
  end
end
