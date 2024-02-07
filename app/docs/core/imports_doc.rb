# frozen_string_literal: true

module Core
  class ImportsDoc < Schematics::ApplicationDoc
    route_base ImportsController.controller_path

    api :create, 'Import resources with a CSV file' do
      data 'import[file]', ::String, required: true

      body :json, data: {
        import: {
          file: ::String
        }
      }

      response 201, 'Success', :json, data: ::Import
        .entity
        .renderable_elements_without_has_many_associations
        .stable_sort_by(&:weight)
        .to_h { [_1.name, _1.open_api_type] }
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
