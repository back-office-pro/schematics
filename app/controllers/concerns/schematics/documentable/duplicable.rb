# frozen_string_literal: true

module Schematics
  module Documentable
    module Duplicable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :duplicate, "Duplicate #{entity.name}" do
          path :id, ::String

          response 201, 'Success', :json, data: entity
            .renderable_elements_without_has_many_associations
            .stable_sort_by(&:weight)
            .to_h { [_1.name, _1.open_api_type] }
          response 400, 'Bad Request', :json
          response 401, 'Not Authorized', :json
          response 422, 'Unprocessable entity', :json
        end
      end
    end
  end
end
