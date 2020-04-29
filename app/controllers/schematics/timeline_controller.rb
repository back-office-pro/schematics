module Schematics
  class TimelineController < ApplicationController
    def show
      @pagy, @versions = pagy(
        PaperTrail::Version.with_user.with_item.order(created_at: :desc),
        items: 25
      )
    end
  end
end
