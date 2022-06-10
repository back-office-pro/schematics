# frozen_string_literal: true

module Schematics
  class FilterByUserPreferencesVersionQuery < ApplicationQuery
    def call = joins(:user).where(
      <<~SQL.squish
        users.preferences -> CONCAT(versions.event, '_', versions.item_type) = 'true' OR
        users.preferences -> CONCAT(versions.event, '_', versions.item_type) IS NULL
      SQL
    )

    protected

    def model_class = Version
  end
end
