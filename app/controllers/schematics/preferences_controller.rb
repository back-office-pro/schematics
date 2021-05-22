# frozen_string_literal: true

module Schematics
  class PreferencesController < ApplicationController
    def edit; end

    def update
      result = Resources::Update.call(
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
            render :edit
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
      return value == 'true' if value.in?(%w[true false])

      value
    end

    def permitted_preference_params
      @permitted_preference_params ||= Schematics::Schema
                                       .instance
                                       .entities
                                       .sort_by(&:name)
                                       .flat_map(&method(:preferences_by_entity))
                                       .map(&:to_sym)
                                       .push(:sidebar_toggled, :theme)
    end

    def preferences_by_entity(entity)
      PaperTrail::Version::EVENTS
        .select { |action| current_ability.can?(action.to_sym, entity.class_name.constantize) }
        .map { |action| [action, entity.class_name].join('_') }
    end
  end
end
