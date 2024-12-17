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
                 element.open_api_body_type,
                 default: element.options.default,
                 required: element.required?
          end

          body :json, data: entity.open_api_body

          response 201, 'Success', :json, data: entity.open_api_schema
          response 400, 'Bad Request', :json
          response 401, 'Not Authorized', :json
          response 422, 'Unprocessable entity', :json
        end
      end
    end
  end
end
