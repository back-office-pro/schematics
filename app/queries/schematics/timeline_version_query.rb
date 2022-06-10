# frozen_string_literal: true

module Schematics
  class TimelineVersionQuery < ApplicationQuery
    # :reek:ControlParameter
    def call(ability, versions = nil)
      (versions || self)
        .with_user
        .with_item
        .then_tap { _1.accessible_by(ability) unless versions }
        .then_tap { _1.filter_by_user_preferences unless versions }
        .reorder(created_at: :desc)
        .load_async
    end

    protected

    def model_class = Version
  end
end
