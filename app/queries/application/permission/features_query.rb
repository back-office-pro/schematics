# frozen_string_literal: true

module Application
  module Permission
    class FeaturesQuery < Schematics::ApplicationQuery
      def call = where(model: %w[Import Message Comment Meeting Task])
        .or(where(model: 'Stat', action: 'show'))
    end
  end
end
