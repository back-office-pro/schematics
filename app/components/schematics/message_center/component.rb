# frozen_string_literal: true

module Schematics
  module MessageCenter
    class Component < ApplicationComponent
      delegate :updated_at, :received_messages, to: :current_user

      def messages
        @messages ||= received_messages
                      .with_rich_text_content
                      .includes(author: [avatar_attachment: [blob: :variant_records]])
                      .order(created_at: :desc)
                      .limit(10)
      end

      def unread_count
        @unread_count ||= received_messages
                          .where(read_at: nil)
                          .size
      end

      def display_unread_count
        unread_count >= 10 ? '9+' : unread_count
      end
    end
  end
end
