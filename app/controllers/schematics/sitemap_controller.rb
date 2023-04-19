# frozen_string_literal: true

module Schematics
  class SitemapController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      @posts = ::BlogPost.state_published.all
    end
  end
end
