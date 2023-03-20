# frozen_string_literal: true

module Schematics
  module Navbar
    module MessageCenter
      class Component < ApplicationComponent
        LIMIT = 10

        def display_unread_count
          unread_count >= 10 ? '9+' : unread_count
        end

        def icon = :envelope

        def icon_class
          return 'fa-lg' if unread_count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        def messages
          @messages ||= current_user
                        .received_messages
                        .with_rich_text_content_and_embeds
                        .with_author_avatar
                        .order(created_at: :desc)
                        .limit(LIMIT)
        end

        def render?
          config(:messages_feature_flag) && can?(:index, ::Message)
        end

        def unread_count
          @unread_count ||= current_user
                            .received_messages
                            .unread
                            .load_async
                            .size
        end
      end
    end
  end
end
