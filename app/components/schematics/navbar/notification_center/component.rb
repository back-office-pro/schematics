# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Navbar
    module NotificationCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :read_notifications_at, to: :current_user

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        def icon = :bell

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def count = Version
          .unread(read_notifications_at)
          .timeline(current_ability)
          .count

        memoize def versions = Version
          .timeline(current_ability)
          .limit(LIMIT)
      end
    end
  end
end
