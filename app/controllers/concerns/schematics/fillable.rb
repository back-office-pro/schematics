module Schematics
  module Fillable
    extend ActiveSupport::Concern

    def resource_params
      keys = request.format.json? ? entity.permitted_json_params : entity.permitted_params
      defaults = entity
                 .references_attributes
                 .map { |attribute| [attribute.name, current_user] }
      params
        .require(entity.name.to_sym)
        .permit(keys)
        .with_defaults(defaults)
    end
  end
end
