# frozen_string_literal: true

module Core
  class ImportsDoc < Schematics::ApplicationDoc
    route_base ImportsController.controller_path

    api :create, 'Import resources with JSON data or a CSV file' do
      data 'import[file]', 'file'
      data 'import[resources]', [{}]

      body :json, data: ::Import.entity.open_api_body

      response 201, 'Success', :json, data: ::Import.entity.open_api_schema
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
