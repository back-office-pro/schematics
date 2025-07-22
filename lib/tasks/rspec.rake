# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  namespace :rspec do
    desc 'Load current migration data'
    task prepare: :environment do
      data = ActiveStorage::Blob.services.fetch(:local).download('backups/migration.json')
      PaperTrail.request(enabled: false) do
        Migration.create!(state: Migration::STATE_STATE_FINISHED, data: JSON.parse(data))
      end
    end
  end
end
