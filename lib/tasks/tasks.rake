# frozen_string_literal: true

namespace :schematics do
  namespace :tasks do
    desc 'Bulk import tasks for performance testing'
    task bulk_import: :environment do
      PaperTrail.request(whodunnit: User.first.id) do
        10_000.times do |index|
          Comment.create!(
            content: SecureRandom.base58,
            author: User.first,
            record: Task.create!(
              title: SecureRandom.base58,
              content: SecureRandom.base58,
              applicant: User.first,
              assigneds: [User.first]
            )
          )
          puts "Task #{index.next} created!"
        end
      end
    end
  end
end
