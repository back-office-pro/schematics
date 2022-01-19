# frozen_string_literal: true

module Schematics
  class VersionsDoc < ApplicationDoc
    route_base VersionsController.controller_path

    api :index, 'History' do
      query :page, 'integer', desc: 'Page number'
      query :items, 'integer', desc: 'Items per page'
      response 200, 'Success', :json
      response 401, 'Not Authorized', :json
    end

    api :show, 'Show diff' do
      path :id, 'string'
      response 200, 'Success', :json, data: [
        {
          item_type: 'string',
          event: 'string',
          item_id: 'string',
          whodunnit: 'string'
        }
      ]
      response 404, 'Not Found', :json
      response 401, 'Not Authorized', :json
    end

    api :revert, 'Revert version' do
      path :id, 'string'
      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
      response 404, 'Not Found', :json
      response 400, 'Bad Request', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
