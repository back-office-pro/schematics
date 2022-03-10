# frozen_string_literal: true

module Schematics
  module NotificationCenter
    class Component < ApplicationComponent
      delegate :versions_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :read_notifications_at, :preferences, to: :current_user

      def versions
        @versions ||= Version
                      .timeline(ability: current_ability)
                      .limit(10)
      end

      def unread_count
        @unread_count ||= Version
                          .where(created_at: read_notifications_at...)
                          .timeline(ability: current_ability)
                          .size
      end

      def display_unread_count
        unread_count >= 10 ? '9+' : unread_count
      end
    end
  end
end
