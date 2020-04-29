module Schematics
  class TimelineController < ApplicationController
    def show
      @pagy, @versions = pagy(
        PaperTrail::Version.
        where('whodunnit IS NOT ?', nil).
        order(created_at: :desc).
        includes(:item),
        items: 25
      )
      @users = User.where(id: @versions.collect(&:whodunnit).uniq)
    end
  end
end
