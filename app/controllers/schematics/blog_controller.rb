# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    include Redirectable

    skip_before_action :authenticate_user!
    before_action :set_resource, only: :show
    before_action :redirect_to_resource_path, only: :show
    layout 'schematics/blog'

    def index
      @pagy, @posts = pagy(model_class)
    end

    def show; end

    private

    def model_class = ::BlogPost
      .preload_all
      .state_published

    def set_resource
      @resource = model_class.finder(params[:slug])
    end

    def create_redirect_path = blog_index_path
  end
end
