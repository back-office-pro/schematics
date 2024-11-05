# frozen_string_literal: true

module Schematics
  class BlogController < ApplicationController
    include Searchable
    include Redirectable

    allow_unauthenticated_access
    before_action :set_resource, only: :show
    before_action :redirect_to_resource_path, only: :show
    delegate :entity, :human_name, :gender, to: :model_class, private: true
    layout 'schematics/blog'

    def index
      @pagy, @posts = pagy(model_class.state_published.list(filter_params, current_ability))
      fresh_when(@posts)
    end

    def show; end

    private

    def set_resource
      @resource = model_class
                  .preload_all
                  .with_slugs
                  .state_published
                  .load_async
                  .finder(params[:slug])
    end

    def model_class = ::BlogPost

    def resource_path = blog_index_path

    def index_path = blog_index_path
  end
end
