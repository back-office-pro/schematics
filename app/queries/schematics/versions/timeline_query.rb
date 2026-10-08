# frozen_string_literal: true

module Schematics
  module Versions
    class TimelineQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(ability, versions = nil)
        (versions || self)
          .with_user
          .then_tap { it.accessible_by(ability) unless versions }
          .then_tap { it.filter_by_user_preferences unless versions }
          .order(created_at: :desc)
      end
    end
  end
end
