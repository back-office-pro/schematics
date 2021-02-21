module Schematics
  class TimelineController < ApplicationController
    def show
      @pagy, @versions = pagy_array(
        PaperTrail::Version
          .with_user
          .with_item
          .order(created_at: :desc)
          .select { |version| version.model_class.accessible_by(current_ability) },
        items: 25
      )
    end
  end
end
