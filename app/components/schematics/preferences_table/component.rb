# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      delegate :preferences_path, :root_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :preferences, to: :helpers
      delegate :can?, to: :current_ability

      def events
        Version::EVENTS
      end

      def entities
        Schema
          .instance
          .entities
          .sort_by { _1.class_name.constantize.model_name.human }
      end
    end
  end
end
