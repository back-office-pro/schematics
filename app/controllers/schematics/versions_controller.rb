module Schematics
  class VersionsController < ApplicationController
    def index
      @pagy, @versions = pagy_array(
        PaperTrail::Version.timeline(ability: current_ability), items: 25
      )
    end

    def show
      @version = PaperTrail::Version.find(params[:id])
    end

    def revert
      @version = PaperTrail::Version.find(params[:id])
      @version.reify&.save! || @version.item.really_destroy!
      redirect_to @version.item
    end
  end
end
