# frozen_string_literal: true

namespace :schematics do
  namespace :credentials do
    desc 'Perform credentials backup'
    task backup: :environment do
      filepath = Rails.root.join('config/master.key')
      ActiveStorage::Blob.create_and_upload!(
        key: File.join('backups', filepath.basename),
        io: File.open(filepath),
        filename: filepath.basename,
        content_type: Mime[:text].to_s
      )
    end
  end
end
