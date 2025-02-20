# Copyright © 2025 Dev & Software. All rights reserved.
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
