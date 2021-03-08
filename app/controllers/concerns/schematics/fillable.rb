module Schematics
  module Fillable
    extend ActiveSupport::Concern

    def resource_params
      params
        .require(entity.name.to_sym)
        .permit(permitted_params)
        .with_defaults(resource_defaults)
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
