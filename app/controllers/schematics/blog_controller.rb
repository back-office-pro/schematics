# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'schematics/blog'

    def index
      @pagy, @posts = pagy(model_class)
    end

    def show
      @post = model_class.finder(params[:slug])
    end

    private

    def model_class = ::BlogPost
      .preload_all
      .state_published
  end
end
