# frozen_string_literal: true

module Schematics
  module NotificationCenter
    class Component < ApplicationComponent
      delegate :versions_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :updated_at, :preferences, to: :current_user

      def versions
        PaperTrail::Version
          .timeline(ability: current_ability, preferences: preferences)
          .take(10)
      end

      def unread_count
        PaperTrail::Version
          .where(created_at: updated_at...)
          .timeline(ability: current_ability, preferences: preferences)
          .size
      end
    end
  end
end
