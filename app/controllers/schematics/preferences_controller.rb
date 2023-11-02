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
        .concat(dashboard_preferences)
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

    def dashboard_preferences = [
      :sidebar_toggled,
      :theme,
      { stats: [] },
      { charts: [] }
    ]

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
