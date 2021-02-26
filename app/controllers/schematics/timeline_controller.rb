module Schematics
  class TimelineController < ApplicationController
    def show
      @pagy, @versions = pagy_array(
        PaperTrail::Version.timeline(ability: current_ability), items: 25
      )
    end
  end
end
