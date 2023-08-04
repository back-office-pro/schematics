# frozen_string_literal: true

namespace :schematics do
  namespace :blog_posts do
    desc 'Bulk import blog posts for performance testing'
    task bulk_import: :environment do
      PaperTrail.request(whodunnit: User.first.id) do
        10_000.times do |index|
          Comment.create!(
            content: SecureRandom.base58,
            author: User.first,
            record: BlogPost.create!(
              title: SecureRandom.base58,
              content: SecureRandom.base58,
              author: User.first
            )
          )
          puts "BlogPost #{index.next} created!"
        end
      end
    end
  end
end
