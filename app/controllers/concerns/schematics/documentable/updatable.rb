# frozen_string_literal: true

module Schematics
  module Documentable
    module Updatable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :update, "Update #{entity.name}" do
          path :id, ::String unless entity.is_a?(Entities::Singleton)

          entity.fillable_elements.each do |element|
            data element.input_name,
                 element.open_api_type,
                 default: element.options.default,
                 required: element.required?
          end

          body :json, data: {
            entity.name.to_sym => entity
              .fillable_elements
              .to_h(&:open_api_body)
          }

          response 204, 'Success', :json
          response 400, 'Bad Request', :json
          response 401, 'Not Authorized', :json
          response 404, 'Not Found', :json
          response 422, 'Unprocessable entity', :json
        end
      end
    end
  end
end
