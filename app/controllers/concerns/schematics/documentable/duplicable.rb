# frozen_string_literal: true

module Schematics
  module Documentable
    module Duplicable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :duplicate, "Duplicate #{entity.name}" do
          path :id, ::String

          response 201, 'Success', :json, data: entity.open_api_schema
          response 400, 'Bad Request', :json
          response 401, 'Not Authorized', :json
          response 422, 'Unprocessable entity', :json
        end
      end
    end
  end
end
