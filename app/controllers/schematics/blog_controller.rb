# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'schematics/jumbotron'

    def index
      @articles = ::Article.state_published.all
    end

    def show
      @article = ::Article
        .state_published
        .with_attached_image
        .with_title
        .with_rich_text_content_and_embeds
        .with_author_avatar
        .find_by!(slug: params[:slug])
    end
  end
end
