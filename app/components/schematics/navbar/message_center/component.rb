# frozen_string_literal: true

module Schematics
  module Navbar
    module MessageCenter
      class Component < ApplicationComponent
        LIMIT = 10

        def display_count
          count >= LIMIT ? '9+' : count
        end

        def icon = :envelope

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def messages = current_user
          .messages
          .with_rich_text_content_and_embeds
          .with_author_avatar
          .order(created_at: :desc)
          .limit(LIMIT)

        def render?
          can?(:index, ::Message)
        end

        memoize def count = current_user
          .messages
          .unread
          .load_async
          .count
      end
    end
  end
end
