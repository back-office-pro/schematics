# frozen_string_literal: true

module Schematics
  module Documentable
    module Showable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :show, "Show #{entity.name}" do
          path :id, ::String unless entity in Entities::Singleton

          response 200, 'Success', :json, data: entity
            .renderable_elements
            .stable_sort_by(&:weight)
            .to_h { [_1.name, _1.open_api_type] }
          response 401, 'Not Authorized', :json
          response 404, 'Not Found', :json
        end
      end
    end
  end
end
