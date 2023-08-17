# frozen_string_literal: true

module Schematics
  class PreferencesController < ApplicationController
    def edit; end

    def update
      result = Resources::UpdateAndCache.call(
        resource: current_user,
        resource_params: { preferences: current_user.preferences.merge(preference_params) }
      )
      respond_with result, location: edit_preferences_path
    end

    private

    def cast_param_value(value)
      return value == 'true' if %w[true false].include?(value)

      value
    end

    def dashboard_preferences = [
      :sidebar_toggled,
      :theme,
      { stats: [] },
      { charts: [] }
    ]

    memoize def permitted_preference_params = timeline_preferences
      .concat(viewer_preferences)
      .concat(viewer_col_preferences)
      .concat(dashboard_preferences)

    def preference_params = params
      .require(:preferences)
      .permit(permitted_preference_params)
      .transform_values(&method(:cast_param_value))

    def timeline_preferences = ::Tenant
      .schema
      .entities
      .reject(&:hidden?)
      .flat_map do |entity|
        Version::EVENTS
          .select { |action| can?(action.to_sym, entity.model_class) }
          .map { |action| [action, entity.class_name].join('_') }
      end

    def viewer_preferences = ::Tenant
      .schema
      .entities
      .map { "viewer_#{_1.id}" }

    def viewer_col_preferences = ::Tenant
      .schema
      .entities
      .flat_map(&:listable_elements)
      .map { "col_#{_1.entity.id}_#{_1.id}" }
  end
end
