# frozen_string_literal: true

module Schematics
  module Fillable
    extend ActiveSupport::Concern

    def resource_params = params
      .require(entity.name.to_sym)
      .permit(permitted_params.excluding(disallowed_params))
      .with_defaults(resource_defaults)

    private

    def permitted_params
      return entity.permitted_json_params if request.format.json?

      entity.permitted_params
    end

    def disallowed_params
      current_ability.disallowed_params(action_name.to_sym, @resource || model_class)
    end

    def resource_defaults = entity
      .user_attributes
      .to_h { |attribute| [attribute.name, current_user] }
  end
end
