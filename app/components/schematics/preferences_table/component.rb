# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      delegate :preferences_path, :root_path, to: 'Schematics::Engine.routes.url_helpers'

      def events
        Version::EVENTS
          .map { [_1, t(_1, scope: %i[activerecord attributes permission actions])] }
          .sort_by(&:last)
          .to_h
      end

      def entities
        Schema
          .instance
          .entities
          .reject(&:hidden?)
          .select { Object.const_defined?(_1.class_name) }
          .sort_by { _1.model_class.human_name }
      end
    end
  end
end
