# frozen_string_literal: true

module Schematics
  module Navbar
    module NotificationCenter
      class Component < ApplicationComponent
        VERSIONS_LIMIT = 10
        delegate :versions_path, to: 'Schematics::Engine.routes.url_helpers'
        delegate :read_notifications_at, :preferences, to: :current_user

        def display_unread_count
          unread_count >= 10 ? '9+' : unread_count
        end

        def icon_class
          return 'fa-lg' if unread_count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        def unread_count
          @unread_count ||= Version
                            .where(created_at: read_notifications_at...)
                            .timeline(current_ability)
                            .size
        end

        def versions
          @versions ||= Version
                        .timeline(current_ability)
                        .limit(VERSIONS_LIMIT)
        end
      end
    end
  end
end
