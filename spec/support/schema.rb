# frozen_string_literal: true

def load_current_schema
  PaperTrail.request(enabled: false) do
    Migration.create!(
      state: Migration::STATE_STATE_FINISHED,
      data: JSON.parse(
        ActiveStorage::Blob.services.fetch(:local).download('backups/migration.json')
      )
    )
    Rails.cache.delete('schema')
  end
end
