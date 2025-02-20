# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  namespace :rspec do
    desc 'Run rspec'
    task run: :environment do
      system(
        "bundle exec rspec --default-path #{Schematics::Engine.root.join('lib', 'spec')} -P '*.rb'",
        out: $stdout
      )
    end

    desc 'Load current migration data'
    task prepare: :environment do
      service = ENV['CI'].present? ? :amazon : :local
      data = ActiveStorage::Blob.services.fetch(service).download('backups/migration.json')
      PaperTrail.request(enabled: false) do
        Migration.create!(state: Migration::STATE_STATE_FINISHED, data: JSON.parse(data))
      end
    end
  end
end
