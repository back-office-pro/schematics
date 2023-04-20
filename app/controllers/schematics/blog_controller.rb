# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    include Redirectable

    skip_before_action :authenticate_user!
    before_action :set_resource, only: :show
    before_action :redirect_to_resource_path, only: :show
    delegate :human_name, :gender, to: :model_class, private: true
    layout 'schematics/blog'

    def index
      @pagy, @posts = pagy(model_class.preload_all.state_published)
    end

    def show; end

    private

    def model_class = ::BlogPost

    def set_resource
      @resource = model_class
                  .preload_all
                  .state_published
                  .finder(params[:slug])
    end

    def resource_path = blog_index_path

    def index_path = blog_index_path
  end
end
