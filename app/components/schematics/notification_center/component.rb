module Schematics
  module NotificationCenter
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :current_user, :current_ability, to: :helpers
      delegate :timeline_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :updated_at, to: :current_user

      def versions
        PaperTrail::Version.timeline(ability: current_ability).take(10)
      end

      def unread_count
        PaperTrail::Version.where(created_at: updated_at...).size
      end
    end
  end
end
