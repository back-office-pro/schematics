# frozen_string_literal: true

module Schematics
  module Versions
    class FilterByUserPreferencesQuery < ApplicationQuery
      def call = joins(:user).where(
        <<~SQL.squish
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) = 'true' OR
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) IS NULL
        SQL
      )
    end
  end
end
