# frozen_string_literal: true

module Schematics
  class SitemapController < ApplicationController
    allow_unauthenticated_access

    def show
      @posts = ::BlogPost.state_published
    end
  end
end
