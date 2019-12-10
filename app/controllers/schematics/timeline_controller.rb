module Schematics
  class TimelineController < ::ApplicationController
    def index
      @versions = PaperTrail::Version.where('whodunnit IS NOT ?', nil).order(created_at: :desc).limit(20).includes(:item)
      render json: @versions
    end
  end
end
