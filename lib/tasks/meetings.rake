# frozen_string_literal: true

namespace :schematics do
  namespace :meetings do
    desc 'Bulk import meetings for performance testing'
    task bulk_import: :environment do
      PaperTrail.request(whodunnit: User.first.id) do
        10_000.times do |index|
          Comment.create!(
            content: SecureRandom.base58,
            author: User.first,
            record: Meeting.create!(
              subject: SecureRandom.base58,
              content: SecureRandom.base58,
              creator: User.first,
              participants: [User.first],
              start_at: Time.current,
              end_at: Time.current.tomorrow
            )
          )
          puts "Meeting #{index.next} created!"
        end
      end
    end
  end
end
