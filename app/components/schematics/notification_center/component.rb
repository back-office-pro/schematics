module Schematics
  module NotificationCenter
    class Component < ApplicationComponent
      delegate :versions_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :updated_at, to: :current_user
      delegate :versions_path,
               :notification_preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'

      def versions
        PaperTrail::Version.timeline(ability: current_ability).take(10)
      end

      def unread_count
        PaperTrail::Version.where(created_at: updated_at...).size
      end
    end
  end
end
