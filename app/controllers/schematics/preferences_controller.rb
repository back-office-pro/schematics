# frozen_string_literal: true

module Schematics
  class PreferencesController < ApplicationController
    def edit; end

    def update
      result = Resources::UpdateAndCache.call(
        resource: current_user,
        resource_params: { preferences: current_user.preferences.merge(preference_params) }
      )
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to edit_preferences_path, notice: t(result.message)
          end
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :edit, status: :unprocessable_entity
          end
          format.json do
            render json: { errors: [t(result.message)] },
                   status: :unprocessable_entity
          end
        end
      end
    end

    private

    def preference_params
      params
        .require(:preferences)
        .permit(permitted_preference_params)
        .transform_values(&method(:cast_param_value))
    end

    def cast_param_value(value)
      return value == 'true' if %w[true false].include?(value)

      value
    end

    def permitted_preference_params
      @permitted_preference_params ||= timeline_preferences
                                       .concat(viewer_preferences)
                                       .concat(dashboard_preferences)
    end

    def timeline_preferences
      Schematics::Schema
        .instance
        .entities
        .reject(&:hidden?)
        .flat_map do |entity|
          Version::EVENTS
            .select { |action| can?(action.to_sym, entity.model_class) }
            .map { |action| [action, entity.class_name].join('_') }
        end
    end

    def viewer_preferences
      Schematics::Schema
        .instance
        .entities
        .reject(&:hidden?)
        .flat_map(&:listable_elements)
        .map { |element| "col_#{element.entity.table_name}_#{element.name}" }
    end

    def dashboard_preferences
      %i[sidebar_toggled theme]
    end
  end
end
