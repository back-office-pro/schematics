# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Navbar
    module MessageCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: '::Message.entity'

        def messages_path = resources_path(::Message)

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def messages = current_user
          .messages
          .with_rich_text_content_and_embeds
          .with_author
          .with_author_avatar
          .with_string_translations
          .order(created_at: :desc)
          .limit(LIMIT)

        def render?
          can?(:index, ::Message)
        end

        memoize def count = current_user
          .messages
          .unread
          .async_count
          .value
      end
    end
  end
end
