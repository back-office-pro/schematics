# frozen_string_literal: true

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Rails.cache.write('CORE_VERSION', Schematics::VERSION)
    Schematics::Migration
      .new(Tenant.schema)
      .build_commands
      .flat_map(&:generators)
      .each(&:invoke_all)
  end
end
