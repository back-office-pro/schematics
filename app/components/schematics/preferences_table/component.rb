# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      delegate :preferences_path, :root_path, to: 'Schematics::Engine.routes.url_helpers'

      def model_classes = current_schema
        .entities
        .reject(&:hidden?)
        .filter_map(&:model_class)
        .sort_by(&:human_name)

      def events = Version::EVENTS
        .map { [it, t(it, scope: %i[activerecord enums permission action])] }
        .sort_by(&:last)
        .to_h
    end
  end
end
