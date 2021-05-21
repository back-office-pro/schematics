# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      delegate :entities, to: 'Schematics::Schema.instance'
      delegate :preferences_path, :root_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :preferences, to: :current_user
      delegate :can?, to: :current_ability

      def events
        PaperTrail::Version::EVENTS
      end

      def checked?(action, model_class, preference)
        can?(action.to_sym, model_class) && preferences.fetch(preference, true)
      end
    end
  end
end
