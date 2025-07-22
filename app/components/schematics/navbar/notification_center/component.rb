# Copyright © 2025 Dev & Software. All rights reserved.
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
