# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        LIMIT = 10

        delegate :count, to: :@pagy
        delegate :entity, :human_name, to: :model_class
        delegate :icon, to: :entity
        option :resource

        def before_render
          @pagy, @comments = pagy(
            resource
              .record_comments
              .with_string_translations
              .with_rich_text_content_and_embeds
              .with_author_avatar
              .order(created_at: :desc), limit: LIMIT
          )
        end

        def model_class = ::Comment

        def title = "#{count} #{human_name(count:)}"
      end
    end
  end
end
