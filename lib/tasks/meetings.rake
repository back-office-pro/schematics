# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
