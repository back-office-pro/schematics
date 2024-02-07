# frozen_string_literal: true

module Schematics
  module Documentable
    module Creatable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :create, "Create #{entity.name}" do
          entity.fillable_elements.each do |element|
            data element.input_name,
                 element.open_api_type,
                 default: element.options.default,
                 required: element.required?
          end

          body :json, data: {
            entity.name.to_sym => entity
              .fillable_elements
              .to_h { [_1.name, _1.open_api_type] }
          }

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
