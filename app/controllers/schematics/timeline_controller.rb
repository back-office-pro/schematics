module Schematics
  class TimelineController < ApplicationController
    def show
      @versions = PaperTrail::Version.
        where('whodunnit IS NOT ?', nil).
        order(created_at: :desc).
        limit(20).
        includes(:item)
    end
  end
end
