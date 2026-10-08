# frozen_string_literal: true

module Core
  module Permissions
    class FeaturesQuery < Schematics::ApplicationQuery
      def call = where(model: %w[Import Message Comment Meeting Task])
        .or(where(model: %w[Chart Metric Ranking], action: 'show'))
        .or(where(model: 'ActiveStorage::Blob', action: 'index'))
    end
  end
end
