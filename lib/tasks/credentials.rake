# frozen_string_literal: true

namespace :schematics do
  namespace :credentials do
    desc 'Perform credentials backup'
    task backup: :environment do
      %w[.env config/master.key]
        .map(&Rails.root.method(:join))
        .each do |filepath|
          ActiveStorage::Blob.create_and_upload!(
            key: File.join('backups', filepath.basename),
            io: File.open(filepath),
            filename: filepath.basename,
            content_type: Mime[:text].to_s
          )
        end
    end
  end
end
