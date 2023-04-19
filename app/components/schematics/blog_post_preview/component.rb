# frozen_string_literal: true

module Schematics
  module BlogPostPreview
    class Component < ApplicationComponent
      with_collection_parameter :post
      delegate :blog_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :title, :content, :author, :created_at, to: :@post

      def initialize(post:)
        super
        @post = post
      end

      def caption = content
        .to_plain_text
        .truncate(100)

      def path = blog_path(@post)
    end
  end
end
