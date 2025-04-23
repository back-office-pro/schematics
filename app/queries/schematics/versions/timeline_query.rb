# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Versions
    class TimelineQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(ability, versions = nil)
        (versions || self)
          .with_user
          .then_tap { _1.accessible_by(ability) unless versions }
          .then_tap { _1.filter_by_user_preferences unless versions }
          .reorder(created_at: :desc)
      end
    end
  end
end
