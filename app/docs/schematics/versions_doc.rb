# frozen_string_literal: true

module Schematics
  class VersionsDoc < ApplicationDoc
    route_base VersionsController.controller_path

    api :index, 'History' do
      query :page, ::Integer, desc: 'Page number'
      query :items, ::Integer, desc: 'Items per page'
      response 200, 'Success', :json, data: [
        {
          id: ::String,
          createdAt: ::DateTime,
          event: ::String,
          user: {},
          item: {},
          objectChanges: {}
        }
      ]
      response 401, 'Not Authorized', :json
    end

    api :show, 'Show diff' do
      path :id, ::String
      response 200, 'Success', :json, data: [
        {
          id: ::String,
          createdAt: ::DateTime,
          event: ::String,
          user: {},
          item: {},
          objectChanges: {}
        }
      ]
      response 404, 'Not Found', :json
      response 401, 'Not Authorized', :json
    end

    api :revert, 'Revert version' do
      path :id, ::String
      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
      response 404, 'Not Found', :json
      response 400, 'Bad Request', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
