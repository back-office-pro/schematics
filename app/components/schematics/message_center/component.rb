# frozen_string_literal: true

module Schematics
  module MessageCenter
    class Component < ApplicationComponent
      delegate :received_messages, to: :current_user

      def messages
        @messages ||= received_messages
                      .with_rich_text_content_and_embeds
                      .with_author_avatar
                      .order(created_at: :desc)
                      .limit(10)
      end

      def unread_count
        @unread_count ||= received_messages
                          .unread
                          .size
      end

      def display_unread_count
        unread_count >= 10 ? '9+' : unread_count
      end

      def icon_class
        return 'fa-lg' if unread_count.zero?

        %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
      end
    end
  end
end
