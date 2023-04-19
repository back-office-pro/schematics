# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        delegate :count, to: :@pagy
        delegate :entity, :human_name, to: :model_class
        delegate :icon, to: :entity
        option :resource

        def before_render
          @pagy, @comments = pagy(
            resource
              .comments
              .with_rich_text_content_and_embeds
              .with_author_avatar
              .order(created_at: :desc)
          )
        end

        def model_class = ::Comment

        def title = "#{count} #{human_name(count:)}"
      end
    end
  end
end
