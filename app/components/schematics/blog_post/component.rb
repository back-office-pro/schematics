# frozen_string_literal: true

module Schematics
  module BlogPost
    class Component < ApplicationComponent
      delegate :blog_index_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :title, :image, :content, :author, :created_at, to: :post
      option :post
    end
  end
end
