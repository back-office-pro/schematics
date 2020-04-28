module Schematics
  class TimelineController < ApplicationController
    def show
      @versions = PaperTrail::Version.
        where('whodunnit IS NOT ?', nil).
        order(created_at: :desc).
        includes(:item)
      @users = User.where(id: @versions.collect(&:whodunnit).uniq)
    end
  end
end
