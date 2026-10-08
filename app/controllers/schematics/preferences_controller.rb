# frozen_string_literal: true

module Schematics
  # :reek:MissingSafeMethod
  class PreferencesController < ApplicationController
    include Fillable

    def edit; end

    def update
      result = Resources::Update.call(resource: current_user, resource_params:)
      respond_with result, location: edit_preferences_path
    end

    private

    def model_class = ::User

    def resource_params = super.tap(&method(:cast_and_merge_preferences!))

    memoize def permitted_params = {
      preferences: timeline_preferences
        .concat(viewer_preferences)
        .concat(viewer_col_preferences)
        .concat(dashboard_metrics_preferences)
        .concat(dashboard_charts_preferences)
        .concat(dashboard_rankings_preferences)
        .push(:sidebar_toggled, :theme)
    }

    def cast_and_merge_preferences!(params)
      params
        .fetch(:preferences)
        .transform_values!(&method(:cast_preference_value))
        .reverse_merge!(current_user.preferences)
    end

    def cast_preference_value(value)
      return value == 'true' if %w[true false].include?(value)

      value
    end

    def dashboard_metrics_preferences = ::Dashboard
      .ids
      .map { { "dashboard_metrics_#{it}" => [] } }

    def dashboard_charts_preferences = ::Dashboard
      .ids
      .map { { "dashboard_charts_#{it}" => [] } }

    def dashboard_rankings_preferences = ::Dashboard
      .ids
      .map { { "dashboard_rankings_#{it}" => [] } }

    def timeline_preferences = SchemaCache
      .entities
      .reject(&:hidden?)
      .reject(&:abstract?)
      .flat_map do |entity|
        Version::EVENTS
          .select { |action| can?(action.to_sym, entity.model_class) }
          .map { |action| [action, entity.class_name].join('_') }
      end

    def viewer_preferences = SchemaCache
      .entities
      .reject(&:abstract?)
      .map { "viewer_#{it.id}" }

    def viewer_col_preferences = SchemaCache
      .entities
      .reject(&:abstract?)
      .flat_map(&:listable_elements)
      .map { "col_#{it.entity.id}_#{it.id}" }
  end
end
