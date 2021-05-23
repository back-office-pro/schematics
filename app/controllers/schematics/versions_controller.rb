# frozen_string_literal: true

module Schematics
  class VersionsController < ApplicationController
    def index
      @pagy, @versions = pagy(ApplicationVersion.timeline(ability: current_ability), items: 50)
    end

    def show
      @version = ApplicationVersion.find(params[:id])
    end

    def revert
      @version = ApplicationVersion.find(params[:id])
      @version.reify&.save! || @version.item.really_destroy!
      redirect_to @version.item
    end
  end
end
