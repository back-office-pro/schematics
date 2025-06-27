# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Schematics::Migrator
      .new(ENV.fetch('DATABASE'))
      .build_commands
      .flat_map(&:generators)
      .each(&:invoke_all)
  end
end
