# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Versions
    class FilterByUserPreferencesQuery < ApplicationQuery
      def call = joins(:user).where(
        <<~SQL.squish
          users.preferences -> CONCAT(paper_trail_versions.event, '_', paper_trail_versions.item_type) = 'true' OR
          users.preferences -> CONCAT(paper_trail_versions.event, '_', paper_trail_versions.item_type) IS NULL
        SQL
      )
    end
  end
end
