# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'schematics/jumbotron'

    def index
      @posts = ::BlogPost.state_published.all
    end

    def show
      @post = ::BlogPost
              .state_published
              .with_attached_image
              .with_title
              .with_rich_text_content_and_embeds
              .with_author_avatar
              .finder(params[:slug])
    end
  end
end
