# frozen_string_literal: true

namespace :schematics do
  namespace :messages do
    desc 'Bulk import messages for performance testing'
    task bulk_import: :environment do
      PaperTrail.request(whodunnit: User.first.id) do
        10_000.times do |index|
          Comment.create!(
            content: SecureRandom.base58,
            author: User.first,
            record: Message.create!(
              subject: SecureRandom.base58,
              content: SecureRandom.base58,
              author: User.first,
              recipients: [User.first]
            )
          )
          puts "Message #{index.next} created!"
        end
      end
    end
  end
end
