# frozen_string_literal: true

module Schematics
  class VersionsDoc < ApplicationDoc
    route_base VersionsController.controller_path

    api :index, 'History' do
      query :page, ::Integer, desc: 'Page number'
      query :limit, ::Integer, desc: 'Items per page'

      response 200, 'Success', :json,
               data: [Version::OPEN_API_SCHEMA],
               headers: ::Pagy::DEFAULT[:headers].invert.transform_values { ::Integer }
      response 401, 'Not Authorized', :json
    end

    api :show, 'Show version' do
      path :id, ::String

      response 200, 'Success', :json, data: Version::OPEN_API_SCHEMA
      response 401, 'Not Authorized', :json
      response 404, 'Not Found', :json
    end

    api :revert, 'Revert version' do
      path :id, ::String

      response 204, 'Success', :json
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 404, 'Not Found', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
