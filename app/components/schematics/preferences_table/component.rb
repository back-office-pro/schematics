# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      delegate :entities, to: 'Schematics::Schema.instance'
      delegate :preferences_path, :root_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :preferences, to: :helpers
      delegate :can?, to: :current_ability

      def events
        Version::EVENTS
      end
    end
  end
end
