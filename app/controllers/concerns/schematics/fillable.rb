# frozen_string_literal: true

module Schematics
  module Fillable
    extend ActiveSupport::Concern

    def resource_params
      params
        .require(entity.name.to_sym)
        .permit(permitted_params)
        .with_defaults(resource_defaults)
    end

    def respond_with_value(resource)
      return head :no_content if resource_params.keys.size > 1

      field = entity.find_field_by_name(resource_params.keys.first)
      render json: { field.name => field.format(resource.public_send(field.name)) }
    end

    private

    def permitted_params
      return entity.permitted_json_params if request.format.json?

      entity.permitted_params
    end

    def resource_defaults
      entity
        .references_attributes
        .map { |attribute| [attribute.name, current_user] }
    end
  end
end
