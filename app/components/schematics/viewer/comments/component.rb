# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        delegate :size, to: :comments
        delegate :entity, :human_name, to: :model_class
        delegate :icon, to: :entity
        option :resource

        def comments = resource
          .comments
          .with_rich_text_content_and_embeds
          .preload(:author)
          .order(created_at: :desc)

        def model_class = ::Comment

        def title = "#{size} #{human_name(count: size)}"
      end
    end
  end
end
