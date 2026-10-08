# frozen_string_literal: true

module Schematics
  module PreferencesTable
    class Component < ApplicationComponent
      def model_classes = SchemaCache
        .entities
        .reject(&:hidden?)
        .reject(&:abstract?)
        .filter_map(&:model_class)
        .sort_by(&:human_name)

      def events = Version::EVENTS
        .map { [it, t(it, scope: %i[activerecord enums permission action])] }
        .sort_by(&:last)
        .to_h
    end
  end
end
