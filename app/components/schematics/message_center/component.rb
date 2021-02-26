module Schematics
  module MessageCenter
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :current_user, to: :helpers
      delegate :updated_at, :received_messages, to: :current_user

      def messages
        received_messages
          .with_rich_text_content
          .includes(author: :avatar_attachment)
          .order(created_at: :desc)
          .limit(10)
      end

      def unread_count
        received_messages.size
      end
    end
  end
end
